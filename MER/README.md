# Análisis del caso

## Concesionaria

Una concesionaria de automóviles quiere un sistema que gestione **dos cosas** a la vez: el stock de vehículos y el proceso comercial que lo mueve, desde que un auto entra hasta que se vende, con su financiación y accesorios.
- El stock: El catálogo se organiza en marcas y modelos, pero lo que realmente se administra son unidades físicas, cada una identificada por su VIN, con color, condición (nueva o usada) y un estado que cambia en el tiempo (disponible, reservada, vendida, fuera de exhibición). Cada unidad pertenece a un modelo y está asignada a una sucursal. Los vehículos nuevos entran por adquisiciones a proveedores, que pueden incorporar varias unidades de una vez.
- La operación comercial: Lo importante es el boleto de compra-venta, que une a un cliente, un vendedor y la unidad que se quiere adquirir. Alrededor del boleto se agregan los elementos opcionales: un plan de financiación con su cronograma de pagos programados, accesorios y la entrega de un vehículo como parte de pago.

## Los puntos más sensibles  del modelo:
- La entrega como parte de pago hace que el boleto se relacione con UNIDAD de dos maneras distintas: el vehículo que se compra y el que se entrega, este último con el atributo monto reconocido. Esa unidad entregada se incorpora al stock como usada y puede venderse más adelante, por lo que no hace falta una entidad aparte.

- Las entidades débiles, Contacto y Pago programado, no tienen sentido sin su cliente o su boleto, y su clave depende de la entidad fuerte.

- La especialización de empleados en vendedores y administrativos importa porque solo los vendedores gestionan boletos.

Por último, las consultas que el sistema debe responder apuntan a lo que el modelo tiene que soportar: stock disponible por sucursal, ventas realizadas, vehículos recibidos como parte de pago, adquisiciones por proveedor, planes de financiación utilizados y accesorios vendidos con cada vehículo. 

Las entidades identificadas son trece, dos de ellas son entidades débiles. Las relaciones que las unen son del tipo binario. Las complejidades que se presentan son: las entidades débiles, la especialización de los empleados y la entrega de un vehículo usado como una forma de pago.
