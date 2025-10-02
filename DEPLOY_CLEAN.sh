#!/bin/bash
# 🧹 ПОЛНАЯ ОЧИСТКА И ПЕРЕЗАПУСК НА СЕРВЕРЕ
# Используй ЭТИ команды на сервере после того, как обновишь GitHub

echo "🧹 Starting full cleanup and restart..."

# ШАГ 1: Остановить все процессы Python (если запущены)
echo "🛑 Killing any running Python processes..."
pkill -f gex_etl_production.py
pkill -f json_to_csv_converter.py
pkill -f auto_update_pine.py
sleep 2

# ШАГ 2: Перейти в рабочую директорию
cd /opt/gex || exit 1

# ШАГ 3: Удалить ВСЕ старые CSV из локального data/
echo "🗑️ Removing all old CSV files from /opt/gex/data/..."
rm -f data/*.csv
rm -f data/*_CALL_WALL_*.csv
rm -f data/*_PUT_WALL_*.csv
rm -f data/*_SPOT.csv
rm -f data/*_NET_GEX.csv
rm -f data/*_HVL.csv
rm -f data/*_ZERO_GAMMA.csv

# ШАГ 4: Удалить старые JSON
echo "🗑️ Removing old JSON files..."
rm -f pine_seeds/*.json

# ШАГ 5: Получить последний код из GitHub
echo "📥 Pulling latest code from GitHub (gex repo)..."
git fetch --all
git reset --hard origin/main
git pull origin main

# ШАГ 6: Обновить pine-seeds репозиторий
echo "📥 Pulling latest code from GitHub (pine-seeds repo)..."
cd pine-seeds-repo || exit 1
git fetch --all
git reset --hard origin/main
git pull origin main

# Удалить все CSV из pine-seeds-repo/data/ (они будут созданы заново)
echo "🗑️ Cleaning pine-seeds-repo/data/..."
rm -f data/*.csv

cd ..

# ШАГ 7: Активировать виртуальное окружение
echo "🐍 Activating Python venv..."
source venv/bin/activate

# ШАГ 8: Установить/обновить зависимости
echo "📦 Installing/updating Python dependencies..."
pip install --upgrade pip
pip install requests numpy

# ШАГ 9: Создать/обновить лог файл
echo "📝 Setting up log file..."
touch /var/log/gex.log
chmod 666 /var/log/gex.log

echo ""
echo "✅ ======================================================"
echo "✅ CLEANUP COMPLETE!"
echo "✅ ======================================================"
echo ""
echo "📋 NEXT STEPS:"
echo "   1. Проверь, что код обновлен:"
echo "      head -5 /opt/gex/json_to_csv_converter.py"
echo ""
echo "   2. ТЕСТОВЫЙ запуск (1 символ SPY):"
echo "      cd /opt/gex"
echo "      source venv/bin/activate"
echo "      export POLYGON_API_KEY=\"Cev3UfH7tQZ1A7VhIwem0OoQ9zkGk9o1\""
echo "      python3 -c \"from gex_etl_production import calculate_gex_from_chain, validate_gex_data, create_pine_seed_format, save_pine_seed; gex = calculate_gex_from_chain('SPY'); print('✅ SPY OK' if gex and validate_gex_data(gex) else '❌ FAIL')\""
echo ""
echo "   3. ПОЛНЫЙ запуск (119 символов, ~30 мин):"
echo "      cd /opt/gex && ./cron.sh"
echo ""
echo "   4. Мониторинг логов (в другом терминале):"
echo "      tail -f /var/log/gex.log"
echo ""
