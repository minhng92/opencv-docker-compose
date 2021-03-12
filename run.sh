#!/bin/bash
set -e
: ${jupyter_base_url:='/'}
: ${jupyter_pass:='minh@2021'}

RUNTIME_REQUIREMENTS="/workspace/runtime/requirements.txt"
if [ -e $RUNTIME_REQUIREMENTS ]
then
    pip3 install -r $RUNTIME_REQUIREMENTS
else
    echo "File $RUNTIME_REQUIREMENTS not found"
fi

RUNTIME_STARTUP="/workspace/runtime/startup.sh"
if [ -e $RUNTIME_STARTUP ]
then
    sh $RUNTIME_STARTUP
else
    echo "File $RUNTIME_STARTUP not found"
fi

JPASS=$(python3 -c "from notebook.auth import passwd; print(passwd('$jupyter_pass'))")

echo $jupyter_pass
echo $JPASS

# JupyterLab with no password:
jupyter lab --ServerApp.base_url=$jupyter_base_url --ServerApp.disable_check_xsrf='True' --ip=0.0.0.0 --port=8888 --no-browser --allow-root --ServerApp.token='' --ServerApp.terminado_settings='{"shell_command":["/bin/bash"]}'
