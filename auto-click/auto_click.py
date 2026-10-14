#!/usr/bin/env python3
"""Auto-click : bouge la souris et clique toutes les 60 s pour éviter l'inactivité.

Usage :
    python3 auto_click.py                 # 1 clic toutes les 60 s
    python3 auto_click.py --interval 30   # toutes les 30 s
    python3 auto_click.py --no-click      # bouge seulement la souris

Arrêt : Ctrl+C, ou envoyer la souris dans un coin de l'écran (sécurité pyautogui).
"""
import argparse
import random
import time

import pyautogui

pyautogui.FAILSAFE = True  # souris dans un coin = arrêt immédiat


def nudge(click: bool) -> None:
    x, y = pyautogui.position()
    width, height = pyautogui.size()
    # petit déplacement aléatoire, en restant à l'intérieur de l'écran
    nx = min(max(x + random.randint(-40, 40), 5), width - 5)
    ny = min(max(y + random.randint(-40, 40), 5), height - 5)
    pyautogui.moveTo(nx, ny, duration=0.3)
    if click:
        pyautogui.click()


def main() -> None:
    parser = argparse.ArgumentParser(description="Évite l'inactivité en bougeant/cliquant.")
    parser.add_argument("--interval", type=float, default=60, help="secondes entre deux actions (défaut : 60)")
    parser.add_argument("--no-click", action="store_true", help="ne pas cliquer, seulement bouger la souris")
    args = parser.parse_args()

    print(f"Auto-click actif : une action toutes les {args.interval:g} s. Ctrl+C pour arrêter.")
    try:
        while True:
            nudge(click=not args.no_click)
            print(time.strftime("[%H:%M:%S]"), "souris déplacée" + ("" if args.no_click else " + clic"))
            time.sleep(args.interval)
    except KeyboardInterrupt:
        print("\nArrêté.")
    except pyautogui.FailSafeException:
        print("\nArrêté (souris dans un coin de l'écran).")


if __name__ == "__main__":
    main()
