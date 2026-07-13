#!/bin/bash
echo "🚀 Starting Kali Linux on Railway..."
echo "⚡ Memory: $(free -h | grep Mem | awk '{print $2}')"
echo "💾 CPU: $(nproc) cores"
echo "🌐 IP: $(hostname -I | awk '{print $1}')"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
exec /bin/ttyd -p 7681 -c ${USERNAME}:${PASSWORD} /bin/bash
