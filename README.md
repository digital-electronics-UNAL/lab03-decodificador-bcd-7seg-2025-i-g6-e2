[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-2e0aaae1b6195c2367325f4f02e2d04e9abb55f0b24a779b69b11b9e10269abc.svg)](https://classroom.github.com/online_ide?assignment_repo_id=19716479&assignment_repo_type=AssignmentRepo)
# Lab03: Decodificador BCD a 7segmentos


## Integrantes 

[Sergio Andrés Bolaños Penagos](https://github.com/sergiosinlimites)
<br>
[Juan José Rincón Monsalve](https://github.com/)
<br>
[Johan Camilo Patiño Mogollon](https://github.com/)


## Informe

Indice:

1. [Descripcion]
2. [Objetivos]
3. [Descripción_de_módulos_y_archivos]
4. [Diseño_lógico_y_diagramas]
5. [Simulaciones]
6. [Implementación_en_placa_FPGA]

## 1. Descripción

En este laboratorio se aborda el diseño modular de una interfaz entre datos digitales codificados en BCD (Binary-Coded Decimal) y un display de 7 segmentos. A partir de una entrada de 4 bits que representa dígitos del 0 al 9, el decodificador controla los siete segmentos (a…g) para mostrar la forma gráfica correspondiente. Además:

- *Se integra un módulo de multiplexación que habilita secuencialmente hasta cuatro displays, generando la ilusión de un número de 4 dígitos sin parpadeos perceptibles.

- *Se añade una ALU de 4 bits capaz de realizar operaciones de suma y resta en complemento a 2, con una señal de salida de signo. El signo ("−") se representa en el dígito más significativo mediante un patrón específico de segmentos.

El flujo completo abarca desde la codificación y simulación en VHDL, pasando por la síntesis en Quartus Prime, hasta la implementación física y demostración en una tarjeta FPGA.

## 2. Objetivos

1. Comprender la lógica de mapeo entre códigos BCD y segmentos de display, incluyendo la gestión de valores inválidos (10–15) apagando todos los segmentos.

2. Implementar un decodificador BCD → 7 segmentos en VHDL usando estructuras concurrentes (with-select, when-else).

3. Diseñar un esquema de multiplexación dinámica, que rote la activación de cada display a alta frecuencia (>1 kHz), controlando pines de anodo/cátodo común.

4. Desarrollar una ALU de 4 bits que soporte suma y resta bajo complemento a 2, generando señales de resultado, acarreo (carry) y signo.

5. Simular todos los módulos con testbenches robustos, obteniendo waveforms que validen la funcionalidad para casos límite.

6. Sintetizar y mapear el diseño en FPGA, optimizando tiempos de ruta y utilizando correctamente el archivo de asignación de pines (QSF).

7. Demostrar el sistema en hardware, interpretando resultados en pantalla y diagnosticando posibles discrepancias entre simulación y hardware.


## 3. Descripción de módulos y archivos

A continuación se detallan los módulos Verilog y sus interfaces, explicando su propósito y conexión en el top-level.

### 3.1. sumador_restador_4b.v

Ruta: src/sumador_restador_4b.v

Función: 
    
- Realiza la operación de suma o resta en dos operandos de 4 bits, según el bit de control mode. La resta se implementa mediante complemento a 2 de B y acarreo inicial.

Entradas:

- A[3:0]: Operando A en binario.

- B[3:0]: Operando B en binario.

- mode: Selección de operación (0 = suma, 1 = resta).

Salidas:

- S[3:0]: Resultado de la operación (complemento a 2 si es negativo).

- Co: Acarreo final (indica signo en resta).

Notas de diseño:

- La operación de resta se basa en la propiedad A - B = A + (~B + 1).

- El bit Co (carry-out) se utiliza para distinguir resultados negativos.

### 3.2. bcd_to_7seg.v

Ruta: src/bcd_to_7seg.v

Función: 

- Convierte un valor BCD de 4 bits en la configuración de segmentos a–g para un display de ánodo común.

Entradas:

- bcd[3:0]: Dígito en formato BCD (0–9) o valor hexadecimal (A–F para indicar caracteres especiales).

Salidas

- seg[6:0]: Bits de segmento donde 1 apaga el segmento (ánodo común).

Consideraciones:

- Se emplea lógica combinacional para minimizar retardo.

- Los valores hexadecimales adicionales permiten mostrar guiones u otros símbolos.

### 3.3. sign_bcd.v

Ruta: src/sign_bcd.v

Función: 

- Toma el resultado de 4 bits S y el acarreo Co del sumador/restador, y genera cuatro dígitos BCD: el signo y las tres cifras decimales.

Entradas:

- S[3:0]: Resultado en complemento a 2.

- Co: Indicador de signo (0 = positivo, 1 = negativo).

Salidas:

- digit3: Código BCD del signo (0xA = ‘-’, 0xF = espacio).

- digit2: Centenas.

- digit1: Decenas.

- digit0: Unidades.

Algoritmo:

1. Si Co=1, convierte S de complemento a 2 a valor positivo.

2. Aplica el método Double Dabble para convertir binario a BCD.

3. Asigna digit3 según signo.

Ventajas: 

- Permite mostrar resultados negativos.

- Flexible para expandir a más dígitos si se requiere.

### 3.4. disp_mux.v

Ruta: src/disp_mux.v

Función: 

- Alterna rápidamente entre cuatro dígitos BCD presentándolos en un único bus de segmentos para minimizar la cantidad de pines requeridos.

Entradas:

- clk: Reloj del sistema (~50 MHz).

- d0–d3[3:0]: Dígitos BCD para unidades, decenas, centenas y signo.

Salidas: 

- seg[6:0]: Segmentos del display.

- digit_sel[3:0]: Control de ánodos (activo bajo).

Operación: 

- Un contador interno divide la frecuencia de reloj para generar un pulso cada ~4 ms.

- Un registro sel de 2 bits selecciona qué dígito mostrar.

- La tarea segment() asigna la máscara de segmentos reutilizando la lógica de bcd_to_7seg.

Observaciones: 

- La multiplexación reduce la cantidad de pines de 28 a 11.

- Frecuencia de refresco suficiente para evitar parpadeo.

### 3.5. top.v

Ruta: src/top.v

Función: 

- Módulo principal que instancia y conecta los cuatro submódulos anteriores.

Entradas/Salidas:

- Botones e interruptores para cargar A, B y mode.

- Señal de reloj y salidas de segmentos y ánodos.

### 3.6. Testbenches

Ruta: tb/*.v

Objetivo: 

- Generar patrones de entrada controlados para verificar cada módulo en simulador (ModelSim).

Descripción:

- tb_sumador_restador.v: Prueba combinaciones de suma y resta, revisando S y Co.

- tb_bcd_to_7seg.v: Recorre valores 0–F, comprueba patrones de segmentos.

- tb_disp_mux.v: Simula reloj y secuencia de multiplexación, verifica digit_sel y seg.

## 4. Diseño lógico y diagramas

### 4.1. Sumador/Restador de 4 bits

El sumador/restador se basa en la ecuación:

- Para mode = 0: Suma normal.

- Para mode = 1: Resta implementada como suma de complemento.

- El bit Co sirve como indicador de desbordamiento en resta.

### 4.2. Decodificador BCD a 7 segmentos

Se implementa mediante una estructura case combinacional que asigna a cada valor BCD un patrón de segmentos

### 4.3. Conversión de signo y BCD

Mediante el algoritmo Double Dabble se convierte el resultado binario de 5 bits (bit de signo más 4 bits de magnitud) a tres dígitos BCD. Se inserta un carácter especial para el signo negativo.

### 4.4. Multiplexación de displays

El módulo disp_mux cicla por cada dígito con un período ajustado (~4 ms) para mantener una apariencia estable. Usa un contador para dividir la frecuencia del reloj y un case para seleccionar segmentos y ánodos.

### 4.5. Diagrama de bloques general

El flujo de datos parte de los botones (A, B, mode), pasa por la lógica aritmética, conversión BCD y finalmente multiplexación.

## 5. Simulaciones

Se realizaron simulaciones unitarias para cada módulo, comprobando la correcta lógica antes de la síntesis en hardware.

### 5.1. Simulaciones Sumador/Restador

### 5.2. Simulaciones Decodificador

### 5.3. Simulaciones Multiplexor de displays

## 6. Implementación en placa FPGA

### 6.1. Asignación de pines





