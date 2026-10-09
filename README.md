# Lua + Python Hosting Bot

Railway project files for the Telegram hosting bot.

## Deploy on Railway
1. Upload these files to the root of a new GitHub repository.
2. In Railway, create a new project and deploy from that GitHub repository.
3. Railway uses `nixpacks.toml` to install Python and Lua, installs `requirements.txt`, then runs `python main.py`.

Note: this installs a Lua interpreter. Lua projects that require native modules such as `tdlua` / TDLib need those extra libraries built and installed separately; this repository does not include them.
