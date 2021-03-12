#!/bin/bash
set -e
: ${jupyter_base_url:='/'}
: ${jupyter_pass:='minh@2021'}

JPASS=$(python3 -c "from notebook.auth import passwd; print(passwd('$jupyter_pass'))")

# JupyterLab with no password:
jupyter lab --ServerApp.base_url=$jupyter_base_url --ServerApp.disable_check_xsrf='True' --ip=0.0.0.0 --port=8888 --no-browser --allow-root --ServerApp.token='' --ServerApp.terminado_settings='{"shell_command":["/bin/bash"]}'
