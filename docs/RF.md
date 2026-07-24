# Requisitos Funcionales por Bounded Context (Takodu API)

Este documento detalla los requisitos funcionales para cada uno de los Bounded Contexts (BC) definidos en la arquitectura de **Takodu**.

---

## 1. Identity & Access Management (IAM)
*Gestiona únicamente el registro, autenticación, verificación de tokens y control de sesiones de los usuarios.*

* El sistema debe permitir el inicio de sesión y autenticación de usuarios mediante credenciales tradicionales (correo y contraseña) o a través de integración con Google OAuth 2.0.
* Al momento de registrarse un nuevo usuario con credenciales tradicionales (correo y contraseña), el sistema debe enviar un correo electrónico de verificación y requerir su confirmación obligatoria antes de habilitar el acceso a la cuenta, omitiendo este paso si el registro se realiza a través de Google OAuth 2.0.
* El sistema debe permitir la recuperación de contraseñas olvidadas mediante el envío de un enlace seguro con token de un solo uso por correo electrónico.
* El sistema debe invalidar de forma segura los tokens de sesión (JWT) cuando el usuario cierre sesión o tras un periodo de inactividad configurable (mínimo 30 minutos).
* El sistema debe registrar un historial de auditoría de accesos que incluya dirección IP, fecha/hora, dispositivo y estado de la autenticación (exitoso/fallido).
* El sistema debe validar tokens y enlaces de invitación únicos y temporales enviados a los empleados para permitirles completar su registro en la plataforma.


---

## 2. Billing (Facturación y Pagos)
*Controla el ciclo de vida de los pagos, planes de suscripción y facturación del negocio SaaS.*

* El sistema debe controlar los límites de locales o sucursales permitidos según el plan de suscripción contratado: el pago del plan estándar permite registrar y gestionar exactamente un (1) local o sucursal, mientras que los planes superiores permiten gestionar múltiples locales o sucursales.
* El sistema debe permitir a los clientes la cancelación y renovación de sus planes de suscripción de manera directa en la plataforma.
* El sistema debe soportar ciclos de pago y facturación mensual y anual para todos los planes de suscripción ofrecidos.
* El sistema debe registrar un historial detallado de facturas y transacciones accesible para cada cliente, permitiéndoles visualizar si sus pagos fueron correctos o fallidos y acceder a la visualización y descarga de sus correspondientes comprobantes de pago (bouchers) y facturas.
* El sistema debe generar y enviar de manera automática facturas y recibos al correo del suscriptor tras cada cobro exitoso.
* El sistema debe ejecutar un proceso automático de reintentos (dunning) en caso de pago fallido y suspender temporalmente el acceso del negocio al software tras 3 reintentos fallidos.


---

## 3. Customer Relationship Management (CRM)
*Administra los perfiles, datos de contacto, historial de atención e información de los clientes.*

* El sistema debe permitir registrar, editar y consultar fichas detalladas de clientes finales con datos como nombre completo, DNI/RUC, teléfono, correo electrónico, fecha de nacimiento y dirección.
* El sistema debe integrarse con el proveedor externo Decolecta u otro proveedor de validación de identidad para agilizar el registro y validar la identidad de los clientes en tiempo real mediante su DNI o RUC.
* El sistema debe mantener un historial cronológico completo de las citas reservadas por cada cliente, detallando servicios recibidos, fechas, costo, y el empleado que los atendió.
* El sistema debe proveer una herramienta de búsqueda avanzada para ubicar clientes rápidamente por nombres, DNI/RUC, correo o teléfono.
* El sistema debe registrar explícitamente el consentimiento de tratamiento de datos personales de acuerdo con las normativas de privacidad locales.

---

## 4. Business (Configuración del Negocio y Locales)
*Gestiona la información global del negocio y la configuración operativa de sus sedes y locales.*

* El sistema debe permitir la gestión de una única organización (empresa/negocio) por cuenta, permitiendo configurar y modificar únicamente su nombre.
* El sistema debe restringir la creación y administración de locales o sucursales físicas en función del plan de suscripción activo del usuario: limitando a un máximo de un (1) local para el plan estándar, y permitiendo la creación de múltiples locales para planes superiores.
* El sistema debe permitir configurar y modificar el nombre y una foto para cada local o sucursal física.


---

## 5. Catalog (Catálogo de Servicios)
*Define el catálogo de servicios, sus precios, duraciones y disponibilidad según local o empleado.*

* El sistema debe permitir la creación, edición y eliminación de servicios dentro del catálogo.
* Cada servicio registrado en el catálogo debe contar con nombre, descripción, precio y duración.
* El nombre, la descripción, el precio y la duración de cada servicio deben ser configurables y editables de manera totalmente independiente por cada local o sucursal física.

---

## 6. Scheduling (Agenda y Reservas)
*Gestiona la agenda, reserva de citas, bloqueos de horario, reprogramaciones y cancelaciones sin conflictos.*

* El sistema debe permitir registrar la reserva de citas ingresando un nombre o título para la cita, y asociando la fecha y hora de atención, la duración, el servicio a realizar, el cliente a atender y el empleado asignado.
* El sistema debe mostrar automáticamente las reservas registradas en el calendario personal de cada empleado asignado.
* El sistema debe establecer por defecto que los calendarios de citas son individuales y personales para cada empleado, restringiendo el acceso o visualización del calendario de otros empleados a menos que se habiliten permisos específicos para el rol del usuario.
* El sistema debe permitir al usuario con rol de `Owner` (o roles que tengan asignados los permisos necesarios) visualizar el calendario global consolidado con todas las reservas de los clientes y de todo el personal del local.
* El sistema debe permitir que un empleado visualice únicamente su propio calendario y reservas, impidiendo que vea el de otros empleados, a menos que el rol cuente con el permiso explícito.
* El sistema debe permitir al empleado (o rol asignado) visualizar si su horario laboral o su cita ha sido cancelada o reprogramada.


---

## 7. Workforce (Gestión de Personal)
*Administra los datos del personal, sus turnos, horarios, asignaciones y la gestión de roles y permisos del sistema.*

* El sistema debe permitir la creación, edición y eliminación de roles personalizados dentro de la organización.
* El sistema debe permitir asignar o restringir de manera granular los permisos de cada rol para realizar las siguientes acciones en el sistema:
  - Acceder y ver su propio calendario personal.
  - Ver el calendario global de la sede.
  - Crear, editar y eliminar citas (reservas).
  - Crear, editar y eliminar servicios en el catálogo.
  - Cambiar el nombre y la foto del local o sucursal física.
  - Agregar, editar y eliminar clientes en el CRM.
* El sistema debe permitir asignar uno o más roles personalizados a cada miembro del personal o empleado.
* El sistema debe mantener un registro de auditoría detallado (bitácora de cambios) de todas las acciones del sistema, registrando quién realizó la modificación, la fecha y hora exacta, y el tipo de cambio realizado.
* El sistema debe permitir agregar nuevos empleados al staff mediante el envío automático de una invitación por correo electrónico, quedando la cuenta en estado "pendiente" hasta que el empleado complete su registro a través del enlace recibido.

---

## 8. Analytics (Métricas e Informes)
*Centraliza el cálculo de métricas financieras, popularidad de servicios, rendimiento de empleados y exportación de reportes de manera independiente por cada local o sucursal.*

* El sistema debe permitir visualizar de forma rápida las métricas y reportes operativos filtrados por día, semana y mes, de manera independiente para cada local o sucursal física.
* El sistema debe calcular e informar el total de ingresos generados (cuánto gané/recaudé) acumulado de forma diaria (hoy), semanal y mensual por cada local.
* El sistema debe identificar e informar cuál ha sido el empleado que ha generado la mayor cantidad de ingresos (dinero) para el negocio en el periodo seleccionado y por local.
* El sistema debe mostrar un reporte detallado con todos los servicios del catálogo, identificando cuáles han sido los más y los menos utilizados en el periodo seleccionado y por local.
* El sistema debe identificar al empleado con mayor cantidad de citas atendidas en el periodo seleccionado y por local.
* El sistema debe calcular e identificar al empleado con mayor cantidad de tiempo total atendido en citas por local.
* El sistema debe calcular el tiempo promedio de duración del servicio por cada empleado en cada local.
* El sistema debe mostrar un ranking del personal ordenado por el total de horas de atención acumuladas y cantidad de servicios realizados por local.
* El sistema debe permitir la exportación de todos los reportes operativos y analíticos generados a formato PDF, segmentados por local.


---

## 9. Chatbot (Asistente de IA)
*Integra capacidades de asistente inteligente para interactuar conversacionalmente con los servicios del core, gestionar el historial de chats e integrarse con proveedores de IA.*

* Interfaz de Chat y Consumo de APIs: El asistente de IA debe funcionar como una interfaz de chat interactiva que consume endpoints del backend (queries/HTTP) para realizar consultas y acciones en tiempo real (por ejemplo, visualizar las citas de un cliente).
* Historial de Chat por Empleado: El sistema debe persistir un historial de chat indexado e independiente para cada empleado de la organización que interactúe con el asistente.
* Integración Flexible de Modelos: El sistema debe permitir configurar la comunicación con modelos de lenguaje a través de la API Key de un proveedor externo (e.g. OpenAI, Gemini) o un endpoint a un modelo auto-alojado (Self-host).
* Seguridad y Control de Acceso: El asistente de IA debe adaptar sus respuestas y limitar sus capacidades estrictamente en función del rol y permisos del empleado autenticado.
* Consultas y Operaciones de Citas: El asistente debe permitir el registro de citas y reservas de manera conversacional, debiendo realizar de forma obligatoria preguntas aclaratorias para confirmar todos los datos antes de procesar la reserva.
* Consulta y Gestión del CRM: El asistente debe permitir la creación, edición y consulta de la información de los clientes del CRM a través de comandos en lenguaje natural.
* Resúmenes Analíticos: El asistente de IA debe ser capaz de proporcionar resúmenes conversacionales y explicativos de las analíticas operativas y financieras a solicitud del usuario.
* Configuración de la Organización: El asistente debe permitir la creación de roles, la configuración de horarios y turnos de trabajo, y la gestión del catálogo de servicios de forma conversacional.


---

## 10. Notifications (Notificaciones)
*Encargado de enviar alertas del sistema, correos transaccionales y notificaciones a usuarios y clientes.*

* El sistema debe enviar correos electrónicos transaccionales automáticos para invitar a los nuevos empleados a registrarse en la plataforma.
* El sistema debe enviar correos automáticos de confirmación y recordatorio de citas a los clientes.

---

## 11. AI MCP (Asistente de IA)
*Integra capacidades de asistente inteligente a través de Model Context Protocol.*

* El asistente de IA debe funcionar como una interfaz de chat interactiva que consume endpoints del backend mediante Model Context Protocol (MCP) para realizar consultas y acciones en tiempo real (por ejemplo, visualizar el calendario).
* El asistente de IA debe adaptar sus respuestas y limitar sus capacidades estrictamente en función del rol y permisos del usuario autenticado (por ejemplo, restringiendo la vista de datos a los que el rol del usuario no tenga autorización).
* El asistente de IA debe ser capaz de proporcionar resúmenes conversacionales y explicativos de las analíticas operativas y financieras a solicitud del usuario.
* El asistente de IA debe permitir la creación, edición y consulta de la información de los clientes del CRM a través de comandos en lenguaje natural.
* El asistente de IA debe permitir el registro de citas y reservas de manera conversacional, debiendo realizar de forma obligatoria preguntas aclaratorias y de validación interactiva al usuario para confirmar todos los datos antes de procesar y registrar la reserva.
* El asistente de IA debe permitir la creación de roles, la configuración de horarios y turnos de trabajo, y la gestión del catálogo de servicios (creación, edición y baja) de forma conversacional en el chat.


