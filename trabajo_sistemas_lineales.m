clc
% Lectura de la imagen de entrada
imagen = imread('imagen.bmp');
% Si es una imagen a color
imagen = double(rgb2gray(imagen)); 
b=size(imagen);

%Parametros iniciales

sigma_s = 60;     % Parámetro espacial
sigma_r = 10;     % Parámetro de rango
n = 10;           % Tamaño de la ventana del filtro
n1=ceil(n/2);     % Obtención de los límites de la ventana
  
%filtro bilateral
conv1=0;
wp=0;
for i=n1:b(1)-n1
    for j=n1:b(2)-n1
        for k=1:n
            for l=1:n
            %señal de entrada
            x=imagen(i-n1+k,j-n1+l);
            %respuesta al impulso 
            h=g_sigma(sqrt((-n1+k)^2+(-n1+l)^2),0,sigma_s)*...
              g_sigma(imagen(i-n1+k,j-n1+l),imagen(i,j),sigma_r);
            %suma de convolución
            conv1=conv1+x*h;
            %factor de normalización
            wp= wp+g_sigma(sqrt((-n1+k)^2+(-n1+l)^2),0,sigma_s)*...
            g_sigma(imagen(i-n1+k,j-n1+l),imagen(i,j),sigma_r);
            end
        end
        bf(i-n1+1,j-n1+1)=conv1/wp;
        conv1=0;
        wp=0;
    end  
end

%Convertir la imagen a uint8
bf1 = uint8(bf);

% Mostrar la imagen original y la imagen filtrada
figure;
subplot(1,2,1);imshow(uint8(imagen));title('Imagen Original')
subplot(1,2,2);imshow(bf1);title('Imagen Filtrada')


%función gaussiana
function x = g_sigma(p,q,sigma)
    x = 1/((2*pi)*sigma^2)*exp(-(p-q)*(p-q)/(2*sigma^2));
end
