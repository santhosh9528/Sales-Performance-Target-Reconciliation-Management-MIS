@echo off
title SALES MIS - ONE CLICK AUTOMATION

echo ==========================================
echo       SALES MIS AUTOMATION
echo ==========================================
echo.

cd /d "C:\Users\Hooooo\Downloads\MIS"

echo [1/3] Running Python automation...
echo.

py run_mis_automation.py

if errorlevel 1 (
    echo.
    echo ==========================================
    echo ❌ AUTOMATION FAILED
    echo ==========================================
    pause
    exit /b 1
)

echo.
echo ==========================================
echo ✅ CSV + SQL AUTOMATION COMPLETED
echo ==========================================
echo.

echo [2/3] SQL processing completed.
echo.

echo [3/3] Ready for Power BI refresh.
echo.

echo ==========================================
echo        AUTOMATION FINISHED
echo ==========================================
echo.

