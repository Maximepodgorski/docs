# Auto-click

Petit script qui déplace légèrement la souris et clique toutes les 60 secondes pour éviter l'inactivité.

## Installation

```bash
pip3 install -r requirements.txt
```

## Lancement

```bash
python3 auto_click.py                 # 1 clic toutes les 60 s
python3 auto_click.py --interval 30   # intervalle personnalisé
python3 auto_click.py --no-click      # bouge la souris sans cliquer
```

## Arrêt

- `Ctrl+C` dans le terminal
- ou envoyer la souris dans un coin de l'écran (sécurité de pyautogui)

## macOS

Au premier lancement, autorise ton terminal dans
**Réglages Système → Confidentialité et sécurité → Accessibilité**, sinon la souris ne bougera pas.

## Remarque

Le clic a lieu à l'endroit où se trouve la souris : laisse-la sur une zone neutre (bureau, fenêtre vide).
