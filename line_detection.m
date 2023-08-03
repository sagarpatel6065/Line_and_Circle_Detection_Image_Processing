function L = line_detection(~)
    % Read the image
    Reference_Image = imread("test1.jpg");
    
    % Convert the image to grayscale
    Reference_Image = rgb2gray(Reference_Image);

    % Display the grayscale image
    figure;
    imshow(Reference_Image);

    % Detect edges using the Canny operator
    Edge_Image = edge(Reference_Image, 'canny');

    % Display the edge-detected image
    figure;
    imshow(Edge_Image);

    % Initialize the theta counter
    Theta_Freq = 0.01;

    % Get the size of the input image
    [x, y] = size(Edge_Image);

    % Determine the diagonal of the input image
    RHO_limit = norm([x y]);

    % Create vectors for RHO and theta
    RHO = (-RHO_limit:1:RHO_limit);
    theta = (0:Theta_Freq:pi);

    % Determine the number of RHOs and thetas
    num_thetas = numel(theta);
    num_RHOs = numel(RHO);

    % Create an ACCUM matrix (Hough space)
    ACCUM = zeros(num_RHOs, num_thetas);

    % Perform the Hough transform
    for xi = 1:x
        for yj = 1:y
            if Edge_Image(xi, yj) == 1
                for theta_id = 1:num_thetas
                    th = theta(theta_id);
                    S = xi * cos(th) + yj * sin(th);
                    RHO_id = round(S + num_RHOs/2);
                    ACCUM(RHO_id, theta_id) = ACCUM(RHO_id, theta_id) + 1;
                end
            end
        end
    end

    % Display the Hough transform
    figure;
    imagesc(theta, RHO, ACCUM);
    title('HOUGH TRANSFORMATION');
    xlabel('Theta(in radians)');
    ylabel('RHO(in pixels)');
    colormap('gray');
    hold on;

    % Extract the parameters of the detected line
    [~, I] = max(ACCUM(:));
    [RHO_id, theta_id] = ind2sub(size(ACCUM), I);

    % Plot the detected line on the Hough transform
    plot(theta(theta_id), RHO(RHO_id), 'o', 'Linewidth', 3);
    hold off;

    % Compute the line coordinates
    Slope_M = -(cos(theta(theta_id)) / sin(theta(theta_id)));
    INTERCEPT_B = RHO(RHO_id) / sin(theta(theta_id));
    x = 1:x;
    y = Slope_M * x + INTERCEPT_B;

    % Plot the detected line superimposed on the original image
    figure;
    subplot(1, 2, 1);
    imagesc(Edge_Image);
    colormap('gray');
    hold on;
    title('EDGED IMAGE');
    plot(y, x, 'r', 'LineWidth', 2);

    subplot(1, 2, 2);
    imagesc(Reference_Image);
    colormap('gray');
    hold on;
    title('GRAYSCALED IMAGE');
    plot(y, x,'r','LineWidth', 2);

    % Return the line coordinates
    L = [x', y'];
end