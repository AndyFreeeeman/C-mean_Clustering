close all

c = 5 ;
m = 1.01 ;
point_per_ball = 15 ;
error_gap = 0.00001 ;

epoch_store = zeros(1,1000);
m_store = zeros(1,1000);

counter = 0;

for cc = 1:1000

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


    end

    


    % ----- average vector -----

    % ----- update u_p+1 -----
    
    for b = 1:point_per_ball * 4
        
        distance = zeros(1,c) ;

        for a = 1:c
            distance(1,a) = sqrt( (point(1,b) - average_vector(1,a))^2 + (point(2,b) - average_vector(2,a))^2 + (point(3,b) - average_vector(3,a))^2 );
        end

       

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

    % ----- calculate error -----

end


epoch_store(1,cc) = epoch_counter ;
m_store(1,cc) = m ;

m = m + 0.0005 ;

counter = counter + 1 ;

disp("generation: " + counter )

end

% ----- main loop -----


% ----- draw -----

plot(m_store,epoch_store,'m-x');

xlabel("m");
ylabel("epoch number");


% ----- draw -----

