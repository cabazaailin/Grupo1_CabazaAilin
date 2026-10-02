def pedir_nombre():
    nombre = input("Ingrese el nombre del estudiante: ").strip()
    while nombre == "":
        print("ERROR: El nombre no puede estar vacío.")
        nombre = input("Ingrese nuevamente el nombre: ").strip()
    return nombre


def pedir_calificacion(numero):
    mensaje = f"Ingrese la calificación {numero}: "
    while True:
        texto = input(mensaje).strip().replace(",", ".")
        try:
            nota = float(texto)
        except ValueError:
            print("ERROR: Debe ingresar un número válido.")
            mensaje = "Ingrese nuevamente la calificación: "
            continue
        if 0 <= nota <= 100:
            return nota
        print("ERROR: La calificación debe estar entre 0 y 100.")
        mensaje = "Ingrese nuevamente la calificación: "


def preguntar_continuar():
    while True:
        respuesta = input("¿Desea registrar otro estudiante? (s/n): ").strip().lower()
        if respuesta in ("s", "n"):
            return respuesta == "s"
        print("ERROR: Responda con 's' para sí o 'n' para no.")


continuar = True

while continuar:
    nombre = pedir_nombre()
    nota1 = pedir_calificacion(1)
    nota2 = pedir_calificacion(2)
    nota3 = pedir_calificacion(3)

    promedio = (nota1 + nota2 + nota3) / 3

    if promedio >= 51:
        estado = "APROBADO"
    else:
        estado = "REPROBADO"

    print("Estudiante:", nombre)
    print("Promedio:", round(promedio, 2))
    print("Estado:", estado)

    continuar = preguntar_continuar()