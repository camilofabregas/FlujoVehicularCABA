# Trabajo Práctico 1 - Grupo 17 - Modelación Númerica - 1er cuatrimestre 2021

#Item a: se vuelca el contenido del archivo en una tabla matriz de 9 columnas
#correspondientes a: Mes, Dia, Hora, DiaSemana, Estación, Sentido, TipoVehículo, 
#FormaPago y CantidadPasos.
datos = load('FlujoVehicular2019.dat'); # Lee el conjunto de datos del archivo.

#------------------------------------------------------

#FUNCIONES LOGICAS

# Recibe una tabla de datos y devuelve una matriz con ingresos y egresos
# totales por hora.
# PRE: Tabla de n filas y 9 columnas con datos del flujo vehicular 2019.
# POST: Devuelve una matriz de 24 filas (que representan las horas) y 2 columnas
# (la primera de ingresos y la segunda de egresos).
function pasPorHora = pasosPorHora(tabla)
  
  pasPorHora = zeros(24,2);
  
  for i = 1:rows(tabla)
    pasPorHora = acumularPasosPorHora(tabla(i,:),pasPorHora);
  endfor
  
endfunction

# Recibe una tabla de datos y calcula el balance para cada hora en una
# estación específica.
# PRE: Tabla de n filas y 9 columnas con datos del flujo vehicular 2019. Número
# indicador de estación de peaje entre 1 y 8.
# POST: Devuelve un vector de 24 posiciones con los balances por hora para la
# estación recibida.
function balPorHora = balanceEstacionPorHora(tabla,estacion)
  
  pasPorHora = zeros(24,2);
  balPorHora = zeros(24,1);
  
  for i = 1:rows(tabla)
    if(tabla(i,5) == estacion)
      pasPorHora = acumularPasosPorHora(tabla(i,:),pasPorHora);
    endif
  endfor
  
  balPorHora = pasPorHora(:,1)-pasPorHora(:,2);
  
endfunction

# Acumula pasos por hora en una matriz y la devuelve.
# PRE: Vector fila de 9 posiciones con datos del flujo vehicular 2019. Matriz
# 'pasos por hora' que contiene los ingresos y egresos acumulados anteriormente.
# POST: Devuelve una matriz de 24x2 con los ingresos y egresos acumulados en
# sus respectivas columnas.
function pasosPorHora = acumularPasosPorHora(fila,pasPorHora)
  
  pasosPorHora = pasPorHora;
  
  if(fila(6) == 1) #Si es ingreso.
    pasosPorHora(fila(3)+1, 1) += fila(9); #Sumo cantidad de ingresos a la hora.
  else #Si es egreso.
    pasosPorHora(fila(3)+1, 2) += fila(9); #Sumo cantidad de egresos a la hora.
  endif
  
endfunction

# Busca y devuelve la estación de peaje con mayor cantidad de pasos totales.
# PRE: Tabla de n filas y 9 columnas con datos del flujo vehicular 2019.
# POST: Devuelve un número entre 1 y 8 correspondiente a la estación con
# mayor cantidad de pasos totales.
function estacion = mayorCantPasos(datos)
  
  pasosPorEstacion = zeros(8,1);
  
  for i = 1:rows(datos)
    pasosPorEstacion(datos(i,5)) += datos(i,9); #Acumula pasos para c/estación.
  endfor
  
  cantPasos = 0;
  
  for j = 1:8
    if(pasosPorEstacion(j)>cantPasos) #Busca estacion con mayor cant. de pasos.
      cantPasos = pasosPorEstacion(j);
      estacion = j;
    endif
  endfor
  
endfunction

# Acumula en un vector la movilidad total para cada hora y lo devuelve.
# PRE: Tabla de n filas y 9 columnas con datos del flujo vehicular 2019.
# POST: Devuelve un vector de 24 posiciones con las movilidades correspondientes
# a cada hora.
function movTotalPorHora = acumularMovilidadPorHora(datos)
    movTotalPorHora = zeros(24,1);
    
    for i = 1:rows(datos)
      movTotalPorHora(datos(i,3)+1) += datos(i,9);
    endfor
   
    disp('Movilidad por hora');
    disp(movTotalPorHora);
    disp('Fin movilidad por hora');
 
 endfunction
 
# Acumula en una matriz las movilidades correspondientes a cada franja horaria
# y la devuelve. Son 22 franjas de 3 horas, la primera franja es desde las 0
# hasta las 2, la segunda desde la 1 hasta las 3 y asi...
# PRE: Vector de 24 posiciones con las movilidades correspondientes
# a cada hora.
# POST: Devuelve matriz de 22 filas (franjas), con el número de franja en la
# primera columna y la movilidad acumulada de la misma en la segunda.
function movilidadPorFranja = acumularMovilidadPorFranja(movilidadPorHora)
   
   movilidadPorFranja = zeros(22,2);
   for i = 1: rows(movilidadPorFranja)
     movilidadPorFranja(i,1) = i;
     movilidadPorFranja(i,2) = movilidadPorHora(i) + movilidadPorHora(i+1) + movilidadPorHora(i+2);
   endfor
   
   disp('Movilidad por franja');
   disp(movilidadPorFranja);
   disp('Fin movilidad por franja');
   
endfunction
 
# Recibe una matriz de movilidades por franja, busca las dos franjas de mayor
# movilidad y las devuelve.
# PRE: Matriz de 22 filas (franjas), con el número de franja en la
# primera columna y la movilidad acumulada de la misma en la segunda.
# POST: Devuelve una matriz 2x2 con las dos filas de mayor movilidad y sus
# respectivas cantidades de pasos totales.
function franjasConMayorMovilidad = obtenerFranjasConMayorMovilidad(movilidadPorFranja)
   franjasConMayorMovilidad = zeros(2,2);
   
   for i = 1:rows(movilidadPorFranja)
     if (movilidadPorFranja(i,2) > franjasConMayorMovilidad(1,2))
       franjasConMayorMovilidad(1,1) = movilidadPorFranja(i,1);
       franjasConMayorMovilidad(1,2) = movilidadPorFranja(i,2);
     endif
   endfor
   
   for i = 1:rows(movilidadPorFranja)
     if (movilidadPorFranja(i,2) > franjasConMayorMovilidad(2,2)) && (movilidadPorFranja(i,1) > (franjasConMayorMovilidad(1,1) + 3)) || (movilidadPorFranja(i,1) < (franjasConMayorMovilidad(1,1) - 3))
       franjasConMayorMovilidad(2,1) = movilidadPorFranja(i,1);
       franjasConMayorMovilidad(2,2) = movilidadPorFranja(i,2);
     endif
   endfor
   
   disp('Franjas con mayor movilidad');
   disp(franjasConMayorMovilidad);
   
endfunction

# Arma un ranking de estaciones con más pasos segun el tipo de vehículo.
# PRE: Tabla de n filas y 9 columnas con datos del flujo vehicular 2019. Número
# indicando el tipo de vehículo (1: liviano, 2: pesado).
# POST: Devuelve un vector de 8 posiciones con los pasos totales para cada 
# estación del tipo de vehículo otorgado.
function estaciones = rankingEstacionesPorTipoVeh(datos, tipoVeh)
  
  estaciones = zeros(8,1);
  
  for i = 1:rows(datos)
    if(datos(i,7) == tipoVeh) # Si el tipo de vehiculo coincide con el solicitado.
      estaciones(datos(i,5)) += datos(i,9); # Acumula pasos de esa estacion
    endif
  endfor

endfunction

# Genera un balance de egresos/ingresos para cada dia de la semana de una estación.
# PRE: Tabla de n filas y 9 columnas con datos del flujo vehicular 2019. Número
# indicador de estación de peaje entre 1 y 8.
# POST: Devuelve una matriz de 7 filas (días de la semana) y 2 columnas, con los
# ingresos de la estación recibida en la primera y los egresos en la segunda.
function balance = balanceEstacionPorDiaSemana(datos, estacion)
  
  balance = zeros(7,2);
  
  for i = 1:rows(datos)
    if (datos(i,5) == estacion)
      if(datos(i,6) == 1) #Si es ingreso.
        balance(datos(i,4),1) += datos(i,9);
      else #Si es egreso.
        balance(datos(i,4),2) += datos(i,9);
      endif
    endif
  endfor
  
  disp(nombreEstacion(estacion));
  disp(balance);
  
endfunction

# Genera un balance de egresos/ingresos para cada mes de una estación.
# PRE: Tabla de n filas y 9 columnas con datos del flujo vehicular 2019. Número
# indicador de estación de peaje entre 1 y 8.
# POST: Devuelve una matriz de 12 filas (meses) y 2 columnas, con los ingresos
# de la estación dada en la primera y los egresos en la segunda.
function balance = balanceEstacionPorMes(datos, estacion)
  
  balance = zeros(12,2);
  
  for i = 1:rows(datos)
    if (datos(i,5) == estacion)
      if(datos(i,6) == 1) #Si es ingreso.
        balance(datos(i,1),1) += datos(i,9);
      else #Si es egreso.
        balance(datos(i,1),2) += datos(i,9);
      endif
    endif
  endfor
  
  disp(nombreEstacion(estacion));
  disp(balance);
  
endfunction

# Cuenta y clasifica por hora los pasos totales que caen en las diferentes 
# situaciones de no cobrabilidad.
# PRE: Tabla de n filas y 9 columnas con datos del flujo vehicular 2019.
# POST: Devuelve matriz 24x4 con los pasos totales por hora (filas) 
# correspondientes a cada forma de pago (columnas).
function pasSinCobrar = pasosSinCobrarPorHora (tabla)
  
  pasSinCobrar = zeros(24,4);
  
  for i = 1:rows(tabla)
    pasSinCobrar = acumularPasosSinCobrarPorHora(tabla(i,:),pasSinCobrar);
  endfor
  
  
endfunction

# Acumula pasos por hora sin cobrabilidad en una matriz y la devuelve.
# PRE: Vector fila de 9 posiciones con datos del flujo vehicular 2019. Matriz
# 'pasos por hora sin cobrar' de 24 filas (horas) por 4 columnas (situaciones
# de no cobrabilidad).
# POST: Devuelve matriz 24x4 con los pasos sin cobrabilidad acumulados por hora.
function pasosSinCobrar = acumularPasosSinCobrarPorHora(fila,pasSinCobrar)
  
  pasosSinCobrar = pasSinCobrar;
  
  switch(fila(8))
    case 102
      pasosSinCobrar(fila(3)+1, 1) += fila(9);
    case 103
      pasosSinCobrar(fila(3)+1, 2) += fila(9);
    case 104
      pasosSinCobrar(fila(3)+1, 3) += fila(9);
    case 105
      pasosSinCobrar(fila(3)+1, 4) += fila(9);
  endswitch
  
endfunction

# Formas de pago para cada día del año.
# PRE: Tabla de n filas y 9 columnas con datos del flujo vehicular 2019.
# POST: Devuelve matriz con 365 filas (días del año) y 2 columnas (pagos en
# efectivo y pagos con Telepase).
function pagos = pagosPorDia(datos)
  
  pagos = zeros(365,2); #1era columna 'Efectivo', 2da columna 'Telepase'
  
  for i=1:rows(datos)
  x = diasHastaMes(datos(i,1)) + datos(i,2);
  if(datos(i,8) == 101)
    pagos(x,1) += datos(i,9);
    else
    pagos(x,2) += datos(i,9);
  endif
  endfor

endfunction

# Devuelve la cantidad de dias hasta el mes dado.
# PRE: Número del 1 al 12 que indica el mes.
# POST: Devuelve un número mayor o igual a 0 correspondiente a la cantidad
# de días del año hasta el mes recibido.
function dias = diasHastaMes(mes)
  
  switch(mes)
   case 1
     dias = 0;
   case 2
     dias = 31;
   case 3
     dias = 59;
   case 4
     dias = 90;
   case 5
     dias = 120;
   case 6
     dias = 151;
   case 7
     dias = 181;
   case 8
     dias = 212;
   case 9
     dias = 243;
   case 10
     dias = 273;
   case 11
     dias = 304;
   case 12
     dias = 334;
  endswitch
  
endfunction

#------------------------------------------------------

#FUNCIONES PARA GRAFICOS

# Nombre de las estaciones.
# PRE: Número entre 1 y 8 correspondiente a la estación.
# POST: Devuelve el nombre de la estación recibida. 
function estacion = nombreEstacion(numeroEstacion)
  
  switch(numeroEstacion)
   case 1
     estacion = "Alberti";
   case 2
     estacion = "Avellaneda";
   case 3
     estacion = "Dellepiane";
   case 4
     estacion = "Illia";
   case 5
     estacion = "Paseo del Bajo";
   case 6
     estacion = "Retiro";
   case 7
     estacion = "Salguero";
   case 8
     estacion = "Sarmiento";
  endswitch
  
endfunction

# Imprime gráfico por horas.
# PRE: Figura a imprimir, título del gráfico, etiqueta del eje Y y nombre del
# archivo a donde se guardará la imagen.
# POST: Imprime la figura ajustando el eje X entre las 0 y 24 horas. Guarda 
# la imagen en un archivo.
function imprimirGraficoPorHora(figura, titulo, etiquetaY, nombreArchivo)
  
  title(titulo);
  grid on
  xticks(0:23);
  xtick = get (gca, "xtick");
  xticklabel = strsplit (sprintf ("%dh\n", xtick), "\n", true);
  set (gca, "xticklabel", xticklabel);
  ytick = get (gca, "ytick");
  yticklabel = strsplit (sprintf ("%d\n", ytick), "\n", true);
  set (gca, "yticklabel", yticklabel);
  xlabel("Horas");
  ylabel(etiquetaY);
  print(figura, strcat(nombreArchivo, ".jpg"), "-djpg", "-S800,500");
  
endfunction

# Imprime ranking de estaciones.
# PRE: Figura a imprimir, título del gráfico y nombre del archivo a donde se 
# guardará la imagen.
# POST: Imprime la figura representando en un gráfico de barras los valores
# correspondientes a cada estación. Guarda la imagen en un archivo.
function imprimirRankingEstaciones(figura, titulo, nombreArchivo)
  
  title(strcat("Ranking de estaciones por pasos de", {' '}, titulo, "."));
  grid on
  ytick = get (gca, "ytick");
  yticklabel = strsplit (sprintf ("%d\n", ytick), "\n", true);
  set (gca, "yticklabel", yticklabel);
  estaciones = {"Alberti","Avellaneda","Dellepiane","Illia","Paseo del Bajo","Retiro","Salguero","Sarmiento"};
  set (gca,'xticklabel', estaciones);
  ylabel(strcat("Pasos de", titulo));
  print(figura, strcat(nombreArchivo, ".jpg"), "-djpg", "-S800,500");
  
endfunction

# Imprime gráfico de ingresos/egresos por día de semana.
# PRE: Figura a imprimir, gráfico de la figura, título del gráfico, etiqueta 
# del eje Y y nombre del archivo a donde se guardará la imagen.
# POST: Imprime la figura representando en un gráfico de barras los ingresos y
# egresos correspondientes a cada día de la semana. Guarda la imagen en un archivo.
function imprimirGraficoPorDiaSemana(figura, grafico, titulo, etiquetaY, nombreArchivo)
  
  title(titulo);
  grid on
  ylim([0, 4000000]);
  ytick = get (gca, "ytick");
  yticklabel = strsplit (sprintf ("%d\n", ytick), "\n", true);
  set (gca, "yticklabel", yticklabel);
  diasSemana = {"Domingo","Lunes","Martes","Miércoles","Jueves","Viernes","Sábado"};
  set (gca,'xticklabel', diasSemana);
  ylabel(etiquetaY);
  legend(grafico,'Ingresos','Egresos');
  print(figura, strcat(nombreArchivo, ".jpg"), "-djpg", "-S1000,500");
  
endfunction

# Imprime gráfico de ingresos/egresos por mes.
# PRE: Figura a imprimir, gráfico de la figura, título del gráfico, etiqueta 
# del eje Y y nombre del archivo a donde se guardará la imagen.
# POST: Imprime la figura representando en un gráfico de barras los ingresos y
# egresos correspondientes a cada mes. Guarda la imagen en un archivo.
function imprimirGraficoPorMes(figura, grafico, titulo, etiquetaY, nombreArchivo)
  
  title(titulo);
  grid on
  ylim([0, 2500000]);
  ytick = get (gca, "ytick");
  yticklabel = strsplit (sprintf ("%d\n", ytick), "\n", true);
  set (gca, "yticklabel", yticklabel);
  meses = {"Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"};
  set (gca,'xticklabel', meses);
  ylabel(etiquetaY);
  legend(grafico,'Ingresos','Egresos');
  print(figura, strcat(nombreArchivo, ".jpg"), "-djpg", "-S1000,500");
  
endfunction

# Imprime gráfico de formas de pago en cada día del año 2019.
# PRE: Figura a imprimir, título del gráfico, etiqueta del eje Y y nombre del 
# archivo a donde se guardará la imagen.
# POST: Imprime la figura representando en un gráfico las formas de pago 
# (efectivo y Telepase) para cada día del año 2019. Guarda la imagen en un
# archivo.
function imprimirGraficoPorDias(figura, titulo, etiquetaY, nombreArchivo)
  
  title(titulo);
  grid on
  xticks(0:50:365);
  ytick = get (gca, "ytick");
  yticklabel = strsplit (sprintf ("%d\n", ytick), "\n", true);
  set (gca, "yticklabel", yticklabel);
  xlabel("Días de 2019");
  ylabel(etiquetaY);
  print(figura, strcat(nombreArchivo, ".jpg"), "-djpg", "-S1000,500");
  
endfunction

#------------------------------------------------------

#GRAFICOS

fig = figure;

#Item b: Gráficos de ingresos, egresos y balances totales para cada hora.
plot(0:23, pasosPorHora(datos)(:,1), 'o-b;Todos los días;');
imprimirGraficoPorHora(fig, "Ingresos totales por hora", "Ingresos", "itemb1");
plot(0:23, pasosPorHora(datos)(:,2), 'o-r;Todos los días;');
imprimirGraficoPorHora(fig, "Egresos totales por hora", "Egresos", "itemb2");
plot(0:23, pasosPorHora(datos)(:,1) - pasosPorHora(datos)(:,2), 'o-k;Todos los días;');
imprimirGraficoPorHora(fig, "Balances totales por hora", "Balance", "itemb3");


#Item c: Gráfico de balances totales por hora para estación con mayor movilidad.
estacion = mayorCantPasos(datos);
titulo = strcat("Balances de estación con mayor cantidad de pasos (", nombreEstacion(estacion), ")");
plot(0:23, balanceEstacionPorHora(datos,estacion), 'o-k;Todos los días;');
imprimirGraficoPorHora(fig, titulo, "Balance", "itemc");


#Item d: Gráfico de movilidad total para cada hora y análisis de las franjas
#horarias con mayor cantidad de pasos.
plot(0:23, acumularMovilidadPorHora(datos),'--o;Todos los días;');
title('Movilidad total por hora');
imprimirGraficoPorHora(fig, "Movilidad total por hora", "Movilidad", "itemd");
obtenerFranjasConMayorMovilidad(acumularMovilidadPorFranja(acumularMovilidadPorHora(datos)));


#Item e: Gráficos de rankings de pasos en estaciones para vehículos livianos y
#pesados.
rankingLivianos = rankingEstacionesPorTipoVeh(datos, 1); # 1 = Liviano
rankingPesados = rankingEstacionesPorTipoVeh(datos, 2); # 2 = Pesado
bar(1:8, rankingLivianos);
imprimirRankingEstaciones(fig, "vehiculos livianos", "iteme1");
bar(1:8, rankingPesados);
imprimirRankingEstaciones(fig, "vehiculos pesados", "iteme2");


#Item f: Gráficos de ingresos y egresos por día de semana para cada estación.
for i=1:8
  pasosEstacion = balanceEstacionPorDiaSemana(datos, i);
  barras = bar(1:7, pasosEstacion);
  titulo = strcat("Ingresos/egresos por dia en estación ", {' '}, nombreEstacion(i), ".");
  imprimirGraficoPorDiaSemana(fig, barras, titulo, "Pasos", strcat("itemf",int2str(i)));
endfor


#Item g: Gráficos de ingresos y egresos por mes para cada estación.
for i=1:8
  pasosEstacion = balanceEstacionPorMes(datos, i);
  barras = bar(1:12, pasosEstacion);
  titulo = strcat("Ingresos/egresos por mes en estación", {' '}, nombreEstacion(i), ".");
  imprimirGraficoPorMes(fig, barras, titulo, "Pasos", strcat("itemg",int2str(i)));
endfor


#Item h: Gráficos de pasos totales según forma de condición de no cobrabilidad.
pasosSinCobrar = pasosSinCobrarPorHora(datos);
pasosSCTotales = pasosSinCobrar(:,1) + pasosSinCobrar(:,2) + pasosSinCobrar(:,3) + pasosSinCobrar(:,4);
clf(fig)
hold on
plot(0:23, pasosSinCobrar(:,1), 'o-m;Exento;');
plot(0:23, pasosSinCobrar(:,2), 'x-b;Infraccion;');
plot(0:23, pasosSinCobrar(:,3), 's-r;No cobrado;');
plot(0:23, pasosSinCobrar(:,4), 'd-g;T. Discapacidad;');
imprimirGraficoPorHora(fig, "Pasos sin cobrabilidad por hora.", "Pasos", "itemh1");
hold off
plot(0:23, pasosSCTotales, 'v-k;Total sin cobrabilidad;');
imprimirGraficoPorHora(fig, "Pasos totales sin cobrabilidad por hora.", "Pasos", "itemh2");


#Item i: Gráficos de formas de pago para todos los días del año 2019.
pagos = pagosPorDia(datos);
plot((1:365),pagos(:,1),'.-r;Efectivo;',(1:365),pagos(:,2),'.-b;Telepase;');
imprimirGraficoPorDias(fig, "Forma de pago por día del año.", "Pagos", "itemi");

#------------------------------------------------------

 
 
 
 
 
 
 
 
 
 
 
 
 
