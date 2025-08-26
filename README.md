# Text-to-SQL AI Analyst

A web-based application that leverages Large Language Models (LLMs) to translate natural language questions into executable MS-SQL queries, displaying the results in a user-friendly interface.

## \#\# Description

This project provides an intuitive chat-like interface for non-technical users to query a database by simply asking questions in plain English. The Python Flask backend processes the user's question, combines it with the relevant database schema and a set of predefined rules, and sends it to an LLM (either a local Ollama instance or the Google Gemini API). The LLM returns a SQL query, which is then executed against a Microsoft SQL Server database. The results are displayed as a table on the webpage, with options to view the generated SQL, see the raw LLM output for debugging, and download the results as a CSV file.

The application is designed to be modular and configurable, with all prompts, rules, and connection settings managed in external files.

-----

## \#\# Features

  * **Natural Language Querying:** Ask complex questions in plain English and receive data-driven answers.
  * **Dual LLM Support:** Easily switch between a local Ollama instance or the Google Gemini API via a configuration setting.
  * **Modular Prompts:** SQL generation rules ("clues") and schema definitions are stored in external files and can be reloaded without restarting the server.
  * **Dynamic UI:** The user interface is clean and responsive, featuring:
      * An auto-expanding, multi-line input box for long questions.
      * Informational pop-ups (in new tabs) to view the known database schemas and query rules.
      * Debugging panels to view the exact SQL query executed and the raw LLM output.
  * **Data Export:** Download query results directly to a `.csv` file with a single click.
  * **IIS Deployment Ready:** Includes a `web.config` file for straightforward deployment on a Windows server running IIS.

-----

## \#\# Technology Stack

  * **Backend:** Python 3, Flask, SQLAlchemy, pandas, pyodbc
  * **Frontend:** HTML5, CSS3, JavaScript (Fetch API)
  * **Database:** Microsoft SQL Server
  * **LLM Providers:** Ollama (for local models), Google Gemini API
  * **Deployment:** IIS with `wfastcgi`

-----

## \#\# Project Structure

```
/your-project-folder
|-- app.py                  # Main Flask application logic
|-- web.config              # IIS deployment configuration
|-- config.ini              # All connection strings, paths, and API keys
|-- templates/
|   |-- index.html          # The single-page frontend
|-- prompt_templates/
|   |-- sql_generation_prompt_json.txt  # Main prompt for the LLM
|   |-- sql_rules.txt       # Modular SQL generation rules ("clues")
|-- schema_definitions/
|   |-- v_rpt_service.sql   # Example schema definition file
|   |-- v_rpt_member.sql    # Example schema definition file
```

-----

## \#\# Setup and Installation

### \#\#\# Prerequisites

  * Python 3.8+
  * Microsoft SQL Server with an accessible database.
  * ODBC Driver for SQL Server.
  * An LLM provider:
      * For **local mode**: An Ollama instance running with a SQL-capable model (e.g., `sqlcoder`).
      * For **Gemini mode**: A valid Google Gemini API key.

### \#\#\# Installation Steps

1.  **Clone the repository:**
    ```shell
    git clone <your-repo-url>
    cd <your-repo-folder>
    ```
2.  **Create a virtual environment (recommended):**
    ```shell
    python -m venv venv
    venv\Scripts\activate
    ```
3.  **Install the required Python packages:**
    ```shell
    pip install Flask pandas sqlalchemy pyodbc google-generativeai requests
    ```

-----

## \#\# Configuration

All application settings are managed in the **`config.ini`** file.

1.  **`[AIProvider]`**: Set `Provider` to either `Local` or `Gemini`.
2.  **`[Schema]`**: Ensure `DefinitionsPath` points to the directory containing your `.sql` table schema files.
3.  **`[Database]`**: Fill in your MS-SQL Server, Database name, username, and password.
4.  **`[Prompts]`**: These paths should be correct by default. `SqlQueryClues` points to the file containing your custom query rules.
5.  **`[LocalAI]` or `[Gemini]`**: Fill in the required settings for your chosen AI provider. For Gemini, paste your Base64-encoded API key into the `ApiKey` field.

-----

## \#\# Running the Application

### \#\#\# For Local Development

To run the application with the built-in Flask development server:

```shell
python app.py
```

The application will be available at `http://127.0.0.1:5000`.

### \#\#\# For Production (IIS)

1.  Ensure you have the `wfastcgi` package installed (`pip install wfastcgi`).
2.  Run `wfastcgi-enable` from an administrative command prompt (one-time setup).
3.  Place the entire project folder in your `C:\inetpub\wwwroot\` directory.
4.  Create a new website in IIS, pointing its physical path to your project folder.
5.  Assign the site to a new or existing Application Pool.
6.  Update the Python paths in **`web.config`** to match your server's Python installation.
7.  Set the site bindings to your desired port and configure firewall rules as needed.
