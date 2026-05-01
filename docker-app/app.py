from flask import Flask, request
import os

app = Flask(__name__)

@app.route('/helado', methods=['POST'])
def crear_helado():
    data = request.json
    sabor = data.get('sabor')
    # Aquí irá la lógica de conexión a Cloud SQL más adelante
    return f"Helado de {sabor} registrado en la base de datos!", 201

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)