function [MAC_total, rho_alt, rho_SL, V_alt, V_SL, Re_Alt, Re_SL, y_MAC_total, Lambda_LE, x_LE_MAC] = Re_calculations(do_plot)
    
    % --- 1. GEOMETRY DEFINITION (Multi-Panel) ---
    y_stations = [0, 1.25, 2.5];        % [m] Spanwise locations (Root, Kink, Tip)
    chords     = [3.739, 3.130, 1.261]; % [m] Chord lengths at those stations
    num_panels = length(y_stations) - 1;
    b_exposed  = y_stations(end);       % Total span = 2.5m
    
    total_area = 0;
    sum_area_mac = 0;
    sum_area_y_mac = 0;
    
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
    end
    
    % --- 2. GLOBAL AERODYNAMIC & GEOMETRIC PARAMETERS ---
    MAC_total   = sum_area_mac / total_area; 
    y_MAC_total = sum_area_y_mac / total_area; 
    Lambda_LE   = rad2deg(atan((chords(1) - chords(end)) / b_exposed)); 
    
    % Calculate the "D" distance (X-coordinate of LE at the y_MAC station)
    x_LE_MAC    = y_MAC_total * tan(deg2rad(Lambda_LE));
    
    % --- 3. EXTREME FLIGHT CASES ---
    rho_SL = 1.225;        % [kg/m^3]
    mu_SL  = 1.789e-5;     % [kg/(m*s)]
    a_SL   = 340.3;        % [m/s]
    V_SL   = 1.5 * a_SL;   % [m/s]
    Re_SL  = (rho_SL * V_SL * MAC_total) / mu_SL; 
    V_stall_SL = 128 * 0.514444444; % [m/s]

    rho_alt = 0.116;       % [kg/m^3]
    mu_alt  = 1.422e-5;    % [kg/(m*s)]
    a_alt   = 295.2;       % [m/s]
    V_alt   = 2.25 * a_alt;% [m/s]
    Re_Alt  = (rho_alt * V_alt * MAC_total) / mu_alt; 
    V_stall_Alt = V_stall_SL*sqrt(rho_SL/rho_alt); % [m/s]
    V_max_Alt = 2414 * 0.277777778 ; % [m/s]
    
   

    if(do_plot)
    
        % --- 5. GENERATE PLANFORM IMAGE WITH MAC ---
        
        figure('Name', 'F-22 Stabilator Multi-Panel Model', 'Color', 'w');
        ax = axes('Color', 'w', 'XColor', 'k', 'YColor', 'k', 'GridColor', 'k', 'GridAlpha', 0.15);
        hold(ax, 'on'); box(ax, 'on'); grid(ax, 'on'); axis(ax, 'equal');
        
        tan_Lambda_LE = tan(deg2rad(Lambda_LE));
        
        x_coords = [0, y_stations(2)*tan_Lambda_LE, y_stations(3)*tan_Lambda_LE, ...
                    y_stations(3)*tan_Lambda_LE + chords(3), y_stations(2)*tan_Lambda_LE + chords(2), ...
                    0 + chords(1)];
        y_coords = [y_stations(1), y_stations(2), y_stations(3), ...
                    y_stations(3), y_stations(2), ...
                    y_stations(1)];
        
        p_stab = patch(x_coords, y_coords, [0.7 0.7 0.7], 'FaceAlpha', 0.8, 'EdgeColor', 'k', 'LineWidth', 1.5);
    
        % Plot the Local Chord at the MAC Station
        c_at_MAC = interp1(y_stations, chords, y_MAC_total);
        x_TE_at_MAC = x_LE_MAC + c_at_MAC; 
        
        l_mac = line([x_LE_MAC, x_TE_at_MAC], [y_MAC_total, y_MAC_total], ...
                    'Color', [0 0 1], 'LineStyle', '--', 'LineWidth', 3);
    
        % Plot the Distance 'D' Line (Red)
        l_dist = line([0, x_LE_MAC], [y_MAC_total, y_MAC_total], ...
                    'Color', [1 0 0], 'LineWidth', 2.5);
        
        text(x_LE_MAC / 2, y_MAC_total - 0.05, sprintf('D = %.3f m', x_LE_MAC), ...
            'Color', [1 0 0], 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    
        % --- Plot Leading Edge Sweep Angle Arc ---
        arc_radius = 0.4; % Reduced radius to ensure it does not overlap with the D line
        theta = linspace(0, deg2rad(Lambda_LE), 30);
        arc_x = arc_radius * sin(theta);
        arc_y = arc_radius * cos(theta);
        plot(ax, arc_x, arc_y, 'k-', 'LineWidth', 1.5);
        
        % Add angle text centered outside the arc, with a smaller font size
        half_angle = deg2rad(Lambda_LE) / 2;
        text_x = (arc_radius + 0.12) * sin(half_angle);
        text_y = (arc_radius + 0.12) * cos(half_angle);
        text(text_x, text_y, sprintf('\\Lambda_{LE} = %.1f^\\circ', Lambda_LE), ...
            'Color', 'k', 'FontSize', 9, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    
        % Add remaining Text Labels
        text(x_coords(end)+0.1, 0.1, sprintf(' \\lambda_{overall}: %.3f', chords(end)/chords(1)), 'Color', 'k', 'FontSize', 11);
    
        % Legend
        l = legend([p_stab, l_mac, l_dist], {'Stabilator Area', sprintf('Local Chord at MAC Station (c = %.3f m)', c_at_MAC), 'Distance D to LE'}, ...
                    'Location', 'northeastoutside');
        set(l, 'FontSize', 11, 'TextColor', 'k', 'EdgeColor', 'k', 'Color', 'w');
        
        title('F-22 Horizontal Stabilator (Movable Area) - Top View', 'Color', 'k', 'FontSize', 13, 'FontWeight', 'bold');
        xlabel('Chord (m)', 'Color', 'k', 'FontSize', 11, 'FontWeight', 'bold'); 
        ylabel('Span (m)', 'Color', 'k', 'FontSize', 11, 'FontWeight', 'bold');
        
        set(gca, 'YDir','reverse', 'FontSize', 10); 
        set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 1 1]); 
        hold(ax, 'off')
    
        script_dir = fileparts(mfilename('fullpath'));
    
        % Build the relative path to the Media folder
        save_path = fullfile(script_dir, '..', 'Report', 'Media', 'Top_View_Stabilator.png');
        
        exportgraphics(gcf, save_path);
    end

end