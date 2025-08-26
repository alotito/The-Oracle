import os
import configparser
import base64
import requests
import pandas as pd
from flask import Flask, request, jsonify, render_template
from sqlalchemy import create_engine
import google.generativeai as genai
import json

# --- Global Variables ---
app = Flask(__name__)
config = configparser.ConfigParser()
DB_SCHEMA_CONTEXT = None
engine = None
AI_PROVIDER = 'local'
genai_client = None
SQL_QUERY_CLUES = None

# --- Core Loading and Configuration Functions ---
def load_all_configs():
    """Master function to load or reload all configurations from files."""
    global config, DB_SCHEMA_CONTEXT, engine, AI_PROVIDER, genai_client, SQL_QUERY_CLUES
    
    config = configparser.ConfigParser()
    config.read('config.ini')
    print("[INFO] config.ini file reloaded.")

    AI_PROVIDER = config.get('AIProvider', 'Provider', fallback='Local').lower()
    print(f"[INFO] AI Provider set to: {AI_PROVIDER}")

    try:
        clues_path = config['Prompts']['SqlQueryClues']
        SQL_QUERY_CLUES = load_file_content(clues_path)
        print(f"[DEBUG] Loaded query clues from {clues_path}")
    except KeyError:
        print("[WARN] SqlQueryClues path not found in config.ini. Clues will be empty.")
        SQL_QUERY_CLUES = ""

    if AI_PROVIDER == 'gemini':
        try:
            encoded_api_key = config['Gemini']['ApiKey']
            decoded_api_key = base64.b64decode(encoded_api_key).decode('utf-8')
            genai.configure(api_key=decoded_api_key)
            genai_client = genai
            print("[DEBUG] Gemini API key decoded and configured successfully.")
        except Exception as e:
            print(f"[WARN] Could not configure Gemini API key. Details: {e}")
            genai_client = None
    else:
        genai_client = None
        print("[DEBUG] AI Provider is 'Local'. Gemini will not be used.")

    DB_SCHEMA_CONTEXT = load_schema_definitions()
    engine = get_database_engine()

def load_file_content(filepath):
    try:
        with open(filepath, 'r') as f:
            return f.read()
    except FileNotFoundError:
        print(f"ERROR: File not found at {filepath}")
        return None

def load_schema_definitions():
    schema_path = config['Schema']['DefinitionsPath']
    all_schemas = []
    try:
        filenames = sorted(os.listdir(schema_path))
        for filename in filenames:
            if filename.endswith(".sql"):
                content = load_file_content(os.path.join(schema_path, filename))
                if content:
                    all_schemas.append(content)
        print(f"[DEBUG] Loaded {len(all_schemas)} schema files: {filenames}")
        return "\n\n---\n\n".join(all_schemas)
    except FileNotFoundError:
        print(f"ERROR: Schema directory not found: {schema_path}")
        return None

def get_database_engine():
    db_config = config['Database']
    connection_string = (
        f"mssql+pyodbc://{db_config['Username']}:{db_config['Password']}"
        f"@{db_config['Server']}/{db_config['Database']}"
        f"?driver={db_config['Driver'].replace(' ', '+')}"
    )
    try:
        db_engine = create_engine(connection_string)
        db_engine.connect().close()
        print("Database connection successful.")
        return db_engine
    except Exception as e:
        print(f"ERROR: Database connection failed. Details: {e}")
        return None

# --- AI Generation Functions (SQL Only) ---
def generate_sql_with_local_ai(prompt):
    cfg = config['LocalAI']
    try:
        payload = {"model": cfg['SqlModel'], "prompt": prompt, "stream": False, "options": {"temperature": cfg.getfloat('SqlTemperature')}}
        response = requests.post(cfg['URL'], json=payload, timeout=60)
        response.raise_for_status()
        return response.json()['response'].strip()
    except requests.exceptions.RequestException as e:
        print(f"Error calling Local AI for SQL generation: {e}")
        return None

def generate_sql_with_gemini(prompt):
    cfg = config['Gemini']
    try:
        model = genai_client.GenerativeModel(cfg['Model'])
        response = model.generate_content(prompt, generation_config=genai_client.types.GenerationConfig(temperature=cfg.getfloat('SqlTemperature')))
        return response.text.strip()
    except Exception as e:
        print(f"Error calling Gemini for SQL generation: {e}")
        return None

def generate_sql(user_question, schema):
    prompt_template = load_file_content(config['Prompts']['SqlGenerationTemplate'])
    if not prompt_template: return "Error: SQL prompt template file not found."
    
    prompt = prompt_template.format(schema=schema, user_question=user_question, query_clues=SQL_QUERY_CLUES)
    
    print("\n" + "="*50)
    print(f"[DEBUG] PROMPT FOR SQL GENERATION ({AI_PROVIDER}):")
    print(prompt)
    print("="*50 + "\n")
    
    if AI_PROVIDER == 'gemini':
        return generate_sql_with_gemini(prompt)
    else:
        return generate_sql_with_local_ai(prompt)

# --- Application Startup ---
load_all_configs()

# --- Flask Routes ---
@app.route('/')
def index():
    return render_template('index.html')

@app.route('/reload_config', methods=['POST'])
def reload_config():
    try:
        load_all_configs()
        return jsonify({"message": "Configuration reloaded successfully!"}), 200
    except Exception as e:
        print(f"ERROR: Failed to reload configuration. Details: {e}")
        return jsonify({"error": f"Failed to reload configuration: {e}"}), 500

@app.route('/get_schemas', methods=['GET'])
def get_schemas():
    if DB_SCHEMA_CONTEXT:
        return jsonify({"schemas_text": DB_SCHEMA_CONTEXT}), 200
    else:
        return jsonify({"error": "Schemas not loaded."}), 500

@app.route('/get_query_clues', methods=['GET'])
def get_query_clues():
    if SQL_QUERY_CLUES:
        return jsonify({"clues_text": SQL_QUERY_CLUES}), 200
    else:
        return jsonify({"error": "Query clues not loaded."}), 500

@app.route('/ask', methods=['POST'])
def ask():
    if not engine or not DB_SCHEMA_CONTEXT:
        return jsonify({"error": "Server is not configured correctly. Check logs."}), 500

    user_question = request.json['question']
    print(f"\n--- NEW REQUEST ---")
    print(f"[DEBUG] Received user question: '{user_question}'")
    
    raw_response = generate_sql(user_question, DB_SCHEMA_CONTEXT)
    if not raw_response:
        return jsonify({"error": "Failed to generate SQL query from the AI model."}), 500
    
    print(f"[DEBUG] Raw response from AI (SQL):\n{raw_response}")

    try:
        clean_response = raw_response.strip().replace("```json", "").replace("```", "")
        sql_data = json.loads(clean_response)
        sql_query = sql_data['sql_query']
    except (json.JSONDecodeError, KeyError):
        print(f"[WARN] Failed to parse JSON. Falling back to string parsing.")
        if "```sql" in raw_response:
            sql_query = raw_response.split("```sql")[1].split("```")[0].strip()
        elif "SELECT" in raw_response.upper():
            sql_query = raw_response[raw_response.upper().find("SELECT"):].strip()
        else:
            return jsonify({
                "error": "AI returned an invalid format. Could not extract SQL query.",
                "raw_llm_output": raw_response
            }), 400
    
    print(f"[DEBUG] EXTRACTED SQL to be executed:\n{sql_query}")

    # --- THIS IS THE CORRECTED VALIDATION LINE ---
    if not sql_query.strip().lower().startswith(("select", "with")):
        return jsonify({
            "error": "Query validation failed. The AI returned a non-SELECT SQL query.",
            "raw_llm_output": raw_response
        }), 400

    try:
        df = pd.read_sql_query(sql_query, engine)
        
        print(f"[DEBUG] Database returned DataFrame with shape: {df.shape}")
        
        result_html = df.to_html(index=False, classes='results-table', border=0) if not df.empty else "<p>No data returned for this query.</p>"
        
        csv_data = df.to_csv(index=False)

        print("--- REQUEST COMPLETE ---\n")
        
        return jsonify({
            "result_html": result_html, 
            "sql_query": sql_query,
            "csv_data": csv_data,
            "raw_llm_output": raw_response
        })

    except Exception as e:
        print(f"ERROR during query execution: {e}")
        return jsonify({
            "error": f"An error occurred during query execution: {e}",
            "sql_query": sql_query,
            "raw_llm_output": raw_response
        }), 500

if __name__ == '__main__':
    app.run(debug=True)