import json
import psycopg2

# Configurar la conexión a la base de datos
conn = psycopg2.connect(
    dbname="comites",
    user="postgres",
    password="ladoblem",
    host="localhost",  # o la dirección de tu servidor PostgreSQL
    port="5432"
)

cursor = conn.cursor()

# Leer el archivo JSON
with open('aprendices.json', 'r') as file:
    aprendices = json.load(file)

# Insertar los datos en la base de datos
for aprendiz in aprendices:
    # Verificar cuántos valores hay en la tupla
    data_tuple = (
        aprendiz['id'], aprendiz['nombres'], aprendiz['apellidos'], aprendiz['tipoDocumento'],
        aprendiz['numeroDocumento'], aprendiz['ficha'], aprendiz['programa'], aprendiz['correoElectronico'],
        aprendiz['rol1'], aprendiz['estado'], aprendiz['coordinacion'], aprendiz['llamadoatencionaprendiz'],
        aprendiz['comitecordinacion'], aprendiz['comitegeneral'], aprendiz['genero']
    )
    print(f"Data to insert: {data_tuple}")  # Esto mostrará los datos que se van a insertar

    # Ejecutar la consulta SQL
    cursor.execute('''
        INSERT INTO comites_api_usuarioaprendiz (id, nombres, apellidos, "tipoDocumento", "numeroDocumento", ficha, programa, "correoElectronico", rol1, estado, coordinacion, llamadoatencionaprendiz, comitecordinacion, comitegeneral, "genero")
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        ON CONFLICT (id) DO UPDATE SET
            nombres = EXCLUDED.nombres,
            apellidos = EXCLUDED.apellidos,
            "tipoDocumento" = EXCLUDED."tipoDocumento",
            "numeroDocumento" = EXCLUDED."numeroDocumento",
            ficha = EXCLUDED.ficha,
            programa = EXCLUDED.programa,
            "correoElectronico" = EXCLUDED."correoElectronico",
            rol1 = EXCLUDED.rol1,
            estado = EXCLUDED.estado,
            coordinacion = EXCLUDED.coordinacion,
            llamadoatencionaprendiz = EXCLUDED.llamadoatencionaprendiz,
            comitecordinacion = EXCLUDED.comitecordinacion,
            comitegeneral = EXCLUDED.comitegeneral,
            "genero" = EXCLUDED."genero";
    ''', data_tuple)

# Confirmar los cambios y cerrar la conexión
conn.commit()
cursor.close()
conn.close()

print("Datos importados correctamente.")
