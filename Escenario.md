# Escenario

## Concesionaria

Una concesionaria de automóviles desea desarrollar un sistema para gestionar integralmente sus
operaciones comerciales y el control de su stock de vehículos.
La empresa comercializa vehículos de distintas marcas y modelos. De cada marca interesa
almacenar su nombre y país de origen. Cada marca posee diversos modelos de vehículos.
De los modelos se requiere conocer su denominación, versión, año de fabricación, precio de lista y si
se encuentra activo para la venta.

La concesionaria administra unidades físicas de vehículos. De cada unidad se necesita almacenar
número de serie (VIN), número de motor, color, fecha de ingreso al stock, condición (Nueva o
Usada), precio de venta y estado actual. Una unidad puede encontrarse disponible, reservada,
vendida o fuera de exhibición. Cada unidad corresponde a un único modelo de vehículo.
La empresa posee varias sucursales. De cada sucursal interesa registrar código identificatorio,
nombre, dirección, teléfono y correo electrónico. Cada unidad de vehículo se encuentra asignada a
una sucursal determinada.

Los clientes interesados en adquirir vehículos deben registrarse en el sistema. De cada cliente se
requiere almacenar tipo y número de documento, nombre completo, domicilio y correo electrónico.
Asimismo, un cliente puede registrar uno o más contactos telefónicos.

De cada contacto interesa almacenar el número telefónico y el nombre de la persona a la que
pertenece dicho contacto, pudiendo tratarse del propio cliente o de una persona de referencia.
La concesionaria cuenta con empleados. De cada empleado se necesita registrar legajo, nombre
completo, fecha de ingreso, teléfono y correo electrónico. Cada empleado desarrolla sus actividades
en una única sucursal. Algunos empleados cumplen funciones de venta y otros funciones
administrativas.

La concesionaria adquiere vehículos nuevos a distintos proveedores. De cada proveedor interesa
registrar CUIT, razón social, domicilio, teléfono y correo electrónico. El ingreso de vehículos al stock
se registra mediante comprobantes de adquisición. De cada adquisición se requiere almacenar
número de comprobante, fecha, tipo de comprobante e importe total. Cada adquisición es emitida
por un único proveedor y puede incorporar una o más unidades de vehículos al stock de la
concesionaria.

El proceso de venta de un vehículo se registra mediante un boleto de compra-venta. De cada boleto
interesa almacenar número, fecha de emisión, importe total y estado. Un boleto puede encontrarse en negociación, confirmado o cancelado. Cada boleto corresponde a un único cliente y es gestionado
por un único vendedor. Asimismo, registra la unidad de vehículo que el cliente desea adquirir.

Como parte de una operación comercial, el cliente puede entregar una unidad vehicular como parte
de pago. Para cada operación en la que esto ocurra, debe registrarse el valor reconocido por la
concesionaria para dicha unidad. Una unidad que ingresa como parte de pago pasa a formar parte
del stock de la empresa y puede volver a comercializarse posteriormente como vehículo usado.
La concesionaria ofrece distintos planes de financiación. De cada plan interesa almacenar un código
identificatorio, descripción, porcentaje máximo financiable, cantidad máxima de cuotas y tasa de
interés anual. Un boleto puede utilizar un plan de financiación determinado.

Cuando una operación se realiza mediante financiación, el sistema debe registrar el plan de pagos
acordado. De cada pago programado interesa almacenar fecha de vencimiento, importe y estado.
Durante una operación de venta pueden ofrecerse accesorios opcionales para el vehículo. De cada
accesorio se requiere almacenar código, descripción, precio y si se encuentra disponible para su
comercialización. Un mismo accesorio puede formar parte de distintas operaciones de venta y una
misma operación puede incluir varios accesorios.

El sistema deberá permitir consultar permanentemente el stock disponible de vehículos por
sucursal, las operaciones de venta realizadas, los vehículos ingresados como parte de pago, las
adquisiciones efectuadas a proveedores, los planes de financiación utilizados y los accesorios
comercializados junto con cada vehículo.

