# Bounded Contexts - Takodu API

A continuación se detalla la responsabilidad de cada uno de los 10 Bounded Contexts en una sola línea:

1. **`iam`**: Gestiona el registro, autenticación, autorización y control de sesiones de los usuarios del sistema.
2. **`billing`**: Controla el ciclo de vida de los pagos, planes de suscripción y facturación del negocio SaaS.
3. **`crm`**: Administra los perfiles, datos de contacto, DNI, cumpleaños y el historial de atención de los clientes finales del negocio.
4. **`business`**: Gestiona la información global del negocio y la configuración operativa de todas sus sedes y locales físicos.
5. **`catalog`**: Define el catálogo de servicios ofrecidos, incluyendo precios, duraciones, y disponibilidad según local o empleado.
6. **`scheduling`**: Gestiona la agenda, reserva de citas, bloqueos de horario, reprogramaciones y cancelaciones sin conflictos.
7. **`workforce`**: Administra los datos del personal, sus roles, turnos laborales, horarios y asignaciones de sedes o servicios.
8. **`analytics`**: Centraliza el cálculo de métricas financieras, popularidad de servicios, rendimiento de empleados y exportación de reportes.
9. **`chatbot`**: Asistente de IA que interactúa por chat para consultar citas, clientes y realizar acciones mediante APIs del core, almacenando el historial por empleado e integrando con proveedores externos de IA.
10. **`notifications`**: Encargado de enviar alertas del sistema, correos transaccionales y notificaciones a usuarios y clientes.
