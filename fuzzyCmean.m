close all

c = 5 ;
m = 1.25 ;
point_per_ball = 1000 ;
error_gap = 0.00001 ;

u0 = zeros(c , point_per_ball * 4) ;
u1 = zeros(c , point_per_ball * 4) ;

point = zeros(3 , point_per_ball * 4) ;

x = 0 ;
y = 0 ;
z = 0 ;

epoch_counter = 0 ; 

final_x = zeros(1,point_per_ball * 4);
final_y = zeros(1,point_per_ball * 4);
final_z = zeros(1,point_per_ball * 4);

for a = 1:c
    for b = 1:point_per_ball * 4
        u0(a , b) = 1 / c ;
    end
end

% for a = 1:c
%     if a / 2 == c
%         u0(a , point_per_ball * 4) = rand ;
%     else
%         u0(a , point_per_ball * 4) = 0 ;
%     end
% end

u0(1 , point_per_ball * 4) = 0.1 ;
u0(2 , point_per_ball * 4) = 0.5 ;
u0(3 , point_per_ball * 4) = 0.3 ;
u0(4 , point_per_ball * 4) = 0.4 ;
u0(5 , point_per_ball * 4) = 0.2 ;

disp(u0)

% ----- generate point -----

for b = 1:point_per_ball * 4 % polar to xyz
    radius = rand ;
    theta = round(rand(1,1)*359) ;
    alpha = round(rand(1,1)*359) ;

    point(1,b) = radius * cos(theta) * sin(alpha) ; % x
    point(2,b) = radius * sin(theta) ; % y
    point(3,b) = radius * cos(theta) * cos(alpha) ; % z

end

for b = 1:point_per_ball
    point(3,b + point_per_ball) = point(3,b + point_per_ball) + 1 ; % ball 2
    point(2,b + point_per_ball * 2) = point(2,b + point_per_ball * 2) + 1 ; % ball 3
    point(1,b + point_per_ball * 3) = point(1,b + point_per_ball * 3) + 1 ; % ball 4
end

% ----- generate point -----

error = 1 ;

% ----- main loop -----

while error > error_gap

    sum_u = 0 ;
    average_vector = zeros(3,c) ;
    epoch_counter = epoch_counter + 1 ; 

    disp("Epoch " + epoch_counter)

    % ----- average vector -----
    
    for a = 1:c
        sum_u = 0 ;
        sum_xu_x = 0 ;
        sum_xu_y = 0 ;
        sum_xu_z = 0 ;
        
        for b = 1:point_per_ball * 4
            sum_u = sum_u + ( u0(a,b)) ^ m ;

            sum_xu_x = sum_xu_x + ( ( u0(a,b)) ^ m ) * point(1,b) ;
            sum_xu_y = sum_xu_y + ( ( u0(a,b)) ^ m ) * point(2,b) ;
            sum_xu_z = sum_xu_z + ( ( u0(a,b)) ^ m ) * point(3,b) ;
        end

        average_vector(1,a) = sum_xu_x / sum_u ;
        average_vector(2,a) = sum_xu_y / sum_u ;
        average_vector(3,a) = sum_xu_z / sum_u ;

        disp("sum_u = " + sum_u)
        disp("sum_xu = " + sum_xu_x + " " + sum_xu_y + " " + sum_xu_z)
    end

    
    
    disp("average_v = " + average_vector)

    % ----- average vector -----

    % ----- update u_p+1 -----
    
    for b = 1:point_per_ball * 4
        
        distance = zeros(1,c) ;

        for a = 1:c
            distance(1,a) = sqrt( (point(1,b) - average_vector(1,a))^2 + (point(2,b) - average_vector(2,a))^2 + (point(3,b) - average_vector(3,a))^2 );
        end

        %disp(b + " distance = " + distance(1,1) + " " + distance(1,2) + " " + distance(1,3) + " " + distance(1,4))

        for a = 1:c

            tem_sum = 0 ;

            for d = 1:c
                tem_sum = tem_sum + ( distance(1,a) / distance(1,d) ) ^ ( 2 / ( m - 1 ) ) ;
            end

            u1(a,b) = ( tem_sum ) ^ (-1) ;
        end
    end

    % ----- update u_p+1 -----

    % ----- calculate error -----

    error = 0 ;
    
    for a = 1:c
        check_sum = 0 ;

        for b = 1:point_per_ball * 4
            check_sum = check_sum + u1(a,b) ; 
        end
            
        if check_sum == 0  
            u1(a,round(rand(1,1)*60)) = 1 ;
        end
    end

    for a = 1:c
        for b = 1:point_per_ball * 4
            error = error + sqrt( (u1(a,b))^2 - (u0(a,b))^2 ) ;
            u0(a,b) = u1(a,b) ;
        end
    end
    
    disp("error = " + error)
    disp(u0)
    % ----- calculate error -----

end

disp("Final u0 ")
disp(u0)

% ----- main loop -----



% ----- draw -----

figure(1)

for b = 1:point_per_ball 
    final_x(1,b) = point(1,b) ;
    final_y(1,b) = point(2,b) ;
    final_z(1,b) = point(3,b) ;
end

scatter3(final_x,final_y,final_z,30,"blue") ;

hold on

for b = 1:point_per_ball 
    final_x(1,b) = point(1,b+point_per_ball ) ;
    final_y(1,b) = point(2,b+point_per_ball) ;
    final_z(1,b) = point(3,b+point_per_ball) ;
end

scatter3(final_x,final_y,final_z,30,"red") ;


for b = 1:point_per_ball 
    final_x(1,b) = point(1,b+point_per_ball*2) ;
    final_y(1,b) = point(2,b+point_per_ball*2) ;
    final_z(1,b) = point(3,b+point_per_ball*2) ;
end

scatter3(final_x,final_y,final_z,30,"green") ;


for b = 1:point_per_ball 
    final_x(1,b) = point(1,b+point_per_ball*3) ;
    final_y(1,b) = point(2,b+point_per_ball*3) ;
    final_z(1,b) = point(3,b+point_per_ball*3) ;
end

scatter3(final_x,final_y,final_z,30,"magenta") ;

xlabel('X');
ylabel('Y');
zlabel('Z');

hold off


figure(2)

colorMarker = zeros(point_per_ball * 4,3);

% red[100] blue[001] green[010] magenta[101] black[000] RGB

final_x = zeros(1,point_per_ball * 4);
final_y = zeros(1,point_per_ball * 4);
final_z = zeros(1,point_per_ball * 4);

for b = 1:point_per_ball * 4
    if u0(1,b) > 0.9 || u0(2,b) > 0.9 || u0(3,b) > 0.9 || u0(4,b) > 0.9 || u0(5,b) > 0.9
        color_r = 0;
        color_g = 0;
        color_b = 0;
    
        final_x(1,b) = point(1,b) ;
        final_y(1,b) = point(2,b) ;
        final_z(1,b) = point(3,b) ;
    
        color_r = color_r + u0(1,b) * 1 + u0(2,b) * 0 + u0(3,b) * 0 + u0(4,b) * 1 + u0(5,b) * 1;
        color_g = color_g + u0(1,b) * 0 + u0(2,b) * 0 + u0(2,b) * 1 + u0(4,b) * 0 + u0(5,b) * 1;
        color_b = color_b + u0(1,b) * 0 + u0(2,b) * 1 + u0(3,b) * 0 + u0(4,b) * 1 + u0(5,b) * 0;

        colorMarker(b,1) = color_r ;
        colorMarker(b,2) = color_g ;
        colorMarker(b,3) = color_b ;
    end
end

scatter3(final_x,final_y,final_z,30,colorMarker,'d') ;


hold on

final_x = zeros(1,point_per_ball * 4);
final_y = zeros(1,point_per_ball * 4);
final_z = zeros(1,point_per_ball * 4);

colorMarker = zeros(point_per_ball * 4,3);

for b = 1:point_per_ball * 4
    if u0(1,b) <= 0.9 && u0(2,b) <= 0.9 && u0(3,b) <= 0.9 && u0(4,b) <= 0.9 && u0(5,b) <= 0.9
        color_r = 0;
        color_g = 0;
        color_b = 0;
    
        final_x(1,b) = point(1,b) ;
        final_y(1,b) = point(2,b) ;
        final_z(1,b) = point(3,b) ;
    
        color_r = color_r + u0(1,b) * 1 + u0(2,b) * 0 + u0(3,b) * 0 + u0(4,b) * 1 + u0(5,b) * 1;
        color_g = color_g + u0(1,b) * 0 + u0(2,b) * 0 + u0(2,b) * 1 + u0(4,b) * 0 + u0(5,b) * 1;
        color_b = color_b + u0(1,b) * 0 + u0(2,b) * 1 + u0(3,b) * 0 + u0(4,b) * 1 + u0(5,b) * 0;

        colorMarker(b,1) = color_r ;
        colorMarker(b,2) = color_g ;
        colorMarker(b,3) = color_b ;
    end
end

scatter3(final_x,final_y,final_z,400,colorMarker,'.') ;

xlabel('X');
ylabel('Y');
zlabel('Z');

% ----- draw -----

