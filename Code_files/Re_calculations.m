function [MAC_total, rho_alt, V_max, V_stall, Re_max, Re_stall, y_MAC_total, Lambda_LE, x_LE_MAC, M_total, X_cg_true, Y_cg_true, I_cg_true] = Re_calculations(do_plot)
    
    % 0. DEFAULT INPUT HANDLING
    if nargin < 1
        do_plot = false; 
    end
    
    % 1. GEOMETRY DEFINITION (Multi-Panel)
    y_stations = [0, 1.25, 2.5];        
    chords     = [3.739, 3.130, 1.261]; 
    num_panels = length(y_stations) - 1;
    b_exposed  = y_stations(end);       
    
    Lambda_LE = rad2deg(atan((chords(1) - chords(end)) / b_exposed)); 
    tan_Lambda_LE = tan(deg2rad(Lambda_LE));
    
    t_ratio = 0.10;              
    rho_honeycomb = 150;         
    k_shell = 0.42;              
    
    M_shaft = 60;                
    Shaft_x = 0.25 * chords(1);  
    Shaft_y = 0.3;               
    
    total_area = 0;
    sum_area_mac = 0;
    sum_area_y_mac = 0;
    
    V_total = 0;
    sum_V_x = 0;
    sum_V_y = 0;

    sum_I_origin = 0;

    cross_section_factor = 0.685 * t_ratio; 
    
    for i = 1:num_panels
        c_root_i = chords(i);
        c_tip_i  = chords(i+1);
        b_i      = y_stations(i+1) - y_stations(i); 
        lambda_i = c_tip_i / c_root_i; 
        
        S_i = (c_root_i + c_tip_i) / 2 * b_i;
        MAC_i = (2/3) * c_root_i * ((1 + lambda_i + lambda_i^2) / (1 + lambda_i));
        y_MAC_local = (b_i / 6) * ((1 + 2*lambda_i) / (1 + lambda_i));
        
        total_area = total_area + S_i;
        sum_area_mac = sum_area_mac + (S_i * MAC_i);
        sum_area_y_mac = sum_area_y_mac + (S_i * (y_stations(i) + y_MAC_local));
        
        V_i = cross_section_factor * b_i * (c_root_i^2 + c_root_i*c_tip_i + c_tip_i^2) / 3; 
        V_total = V_total + V_i;
        
        Y_shell_local = (b_i * (1 + 2*lambda_i + 3*lambda_i^2)) / (4 * (1 + lambda_i + lambda_i^2));
        Y_shell_global = y_stations(i) + Y_shell_local;
        
        X_shell_global = (Y_shell_global * tan_Lambda_LE) + ...
                         (k_shell * c_root_i * (3 * (1 + lambda_i + lambda_i^2 + lambda_i^3)) / (4 * (1 + lambda_i + lambda_i^2)));
                     
        M_i = V_i * rho_honeycomb;
        C_avg_i = (c_root_i + c_tip_i) / 2;
        I_local_i = (1/12) * M_i * C_avg_i^2;

        sum_I_origin = sum_I_origin + I_local_i + M_i * (X_shell_global^2);
        sum_V_y = sum_V_y + (V_i * Y_shell_global);
        sum_V_x = sum_V_x + (V_i * X_shell_global);
    end
    
    % 2. GLOBAL AERODYNAMIC & GEOMETRIC PARAMETERS
    MAC_total   = sum_area_mac / total_area; 
    y_MAC_total = sum_area_y_mac / total_area; 
    
    x_LE_MAC    = y_MAC_total * tan_Lambda_LE;
    
    M_shell = V_total * rho_honeycomb;
    Y_shell_cg = sum_V_y / V_total;
    X_shell_cg = sum_V_x / V_total;
    
    M_total = M_shell + M_shaft;
    X_cg_true = ((M_shell * X_shell_cg) + (M_shaft * Shaft_x)) / M_total;
    Y_cg_true = ((M_shell * Y_shell_cg) + (M_shaft * Shaft_y)) / M_total;
    
    I_shell_cg = sum_I_origin - M_shell * (X_shell_cg^2);
    
    r_shaft = 0.095;
    I_shaft_cg = 0.5 * M_shaft * r_shaft^2;
    
    I_cg_true = I_shell_cg + M_shell * (X_shell_cg - X_cg_true)^2 + ...
                I_shaft_cg + M_shaft * (Shaft_x - X_cg_true)^2;

    % 3. FLIGHT CASES AT 60,000 FT
    rho_alt = 0.116;       
    mu_alt  = 1.422e-5;    
    
    V_max   = 670.55;      
    Re_max  = (rho_alt * V_max * MAC_total) / mu_alt; 
    
    V_stall = 213.987;     
    Re_stall = (rho_alt * V_stall * MAC_total) / mu_alt; 
    
    % 5. GENERATE PLANFORM IMAGE WITH MAC
    if(do_plot)
        figure('Name', 'F-22 Stabilator Multi-Panel Model', 'Color', 'w');
        ax = axes('Color', 'w', 'XColor', 'k', 'YColor', 'k', 'GridColor', 'k', 'GridAlpha', 0.15);
        hold(ax, 'on'); box(ax, 'on'); grid(ax, 'on'); axis(ax, 'equal');
        
        x_coords = [0, y_stations(2)*tan_Lambda_LE, y_stations(3)*tan_Lambda_LE, ...
                    y_stations(3)*tan_Lambda_LE + chords(3), y_stations(2)*tan_Lambda_LE + chords(2), ...
                    0 + chords(1)];
        y_coords = [y_stations(1), y_stations(2), y_stations(3), ...
                    y_stations(3), y_stations(2), ...
                    y_stations(1)];
        
        p_stab = patch(x_coords, y_coords, [0.7 0.7 0.7], 'FaceAlpha', 0.8, 'EdgeColor', 'k', 'LineWidth', 1.5);
    
        c_at_MAC = interp1(y_stations, chords, y_MAC_total);
        x_TE_at_MAC = x_LE_MAC + c_at_MAC; 
        l_mac = line([x_LE_MAC, x_TE_at_MAC], [y_MAC_total, y_MAC_total], 'Color', [0 0 1], 'LineStyle', '--', 'LineWidth', 3);
    
        l_dist = line([0, x_LE_MAC], [y_MAC_total, y_MAC_total], 'Color', [1 0 0], 'LineWidth', 2.5);
        text(x_LE_MAC / 2, y_MAC_total - 0.05, sprintf('D = %.3f m', x_LE_MAC), 'Color', [1 0 0], 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    
        p_cog = plot(ax, X_cg_true, Y_cg_true, 'p', 'MarkerSize', 14, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r');
        text(X_cg_true, Y_cg_true + 0.15, sprintf('CoG (%.2f, %.2f)', X_cg_true, Y_cg_true), 'Color', 'r', 'FontSize', 11, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
            
        arc_radius = 0.4; 
        theta = linspace(0, deg2rad(Lambda_LE), 30);
        arc_x = arc_radius * sin(theta);
        arc_y = arc_radius * cos(theta);
        plot(ax, arc_x, arc_y, 'k-', 'LineWidth', 1.5);
        
        half_angle = deg2rad(Lambda_LE) / 2;
        text_x = (arc_radius + 0.12) * sin(half_angle);
        text_y = (arc_radius + 0.12) * cos(half_angle);
        text(text_x, text_y, sprintf('\\Lambda_{LE} = %.1f^\\circ', Lambda_LE), 'Color', 'k', 'FontSize', 9, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    
        text(x_coords(end)+0.1, 0.1, sprintf(' \\lambda_{overall}: %.3f', chords(end)/chords(1)), 'Color', 'k', 'FontSize', 11);
    
        l = legend([p_stab, l_mac, l_dist, p_cog], ...
            {'Stabilator Area', sprintf('Local Chord at MAC Station (c = %.3f m)', c_at_MAC), 'Distance D to LE', 'Center of Gravity'}, ...
            'Location', 'northeastoutside');
        set(l, 'FontSize', 11, 'TextColor', 'k', 'EdgeColor', 'k', 'Color', 'w');
        
        title('F-22 Horizontal Stabilator (Movable Area) - Top View', 'Color', 'k', 'FontSize', 13, 'FontWeight', 'bold');
        xlabel('Chord (m)', 'Color', 'k', 'FontSize', 11, 'FontWeight', 'bold'); 
        ylabel('Span (m)', 'Color', 'k', 'FontSize', 11, 'FontWeight', 'bold');
        
        set(gca, 'YDir','reverse', 'FontSize', 10); 
        set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 1 1]); 
        hold(ax, 'off')
    
        script_dir = fileparts(mfilename('fullpath'));
        media_folder = fullfile(script_dir, '..', 'Report', 'Media');
        
        if ~exist(media_folder, 'dir')
            mkdir(media_folder);
        end
        
        save_path = fullfile(media_folder, 'Top_View_Stabilator.png');
        exportgraphics(gcf, save_path, 'Resolution', 300)
        
        winopen(save_path); 
    end
end