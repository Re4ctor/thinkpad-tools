
#!/bin/sh

systemctl stop ThinkpadThrottleFix.service
systemctl stop ThinkpadTools.service

mkdir -p "/opt/ThinkpadTools"
set -e

cd "$HOME"

echo "Copying config file..."
if [ ! -f /opt/ThinkpadTools/config.ini ]; then
	cp config.ini /opt/ThinkpadTools/
else
	echo "Config file already exists, skipping."
fi

echo "Copying systemd service file..."
cp ThinkpadThrottleFix.service /etc/systemd/system/
cp ThinkpadTools.service /etc/systemd/system/

echo "Building virtualenv..."
cp -n requirements.txt Handlers.py mmio.py newCPU_throttling_fix.py service_runner.py "/opt/ThinkpadTools/"
cd "/opt/ThinkpadTools"
/usr/bin/python3 -m venv venv
. venv/bin/activate
pip install -r requirements.txt

echo "Enabling and starting service..."
systemctl daemon-reload
systemctl enable ThinkpadTools.service && systemctl restart ThinkpadTools.service
systemctl enable ThinkpadThrottleFix.service && systemctl restart ThinkpadThrottleFix.service

echo "All done."