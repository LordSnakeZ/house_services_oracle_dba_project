
# House Services Oracle DB Project

Centralized repository with Markdown documentation and all SQL/Bash scripts required to deploy, manage, and back up the Oracle database for the *House Services* project.

## How to reproduce

1. Clone the repo  
   ```bash
   git clone https://github.com/<your-user>/house_services_oracle_db_project.git
   cd house_services_oracle_db_project
   ```

2. Review `docs/` for infrastructure decisions.

3. Edit `bootstrap/00-bootstrap.sh` with your Oracle home and SID.

4. Execute:  
   ```bash
   ./bootstrap/00-bootstrap.sh
   ```

## Directory layout

- `docs/` – Markdown documentation.
- `scripts/` – Numbered SQL/Shell scripts.
- `generator/` – Optional data generator utilities.
