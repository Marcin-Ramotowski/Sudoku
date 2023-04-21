% Aplikacja do gry w sudoku
% Marcin Ramotowski
% Program wzorowany na aplikacji Sudoku.com - zagadki liczbowe
% studia EasyBrain dostępnej w GooglePlay Store

createSudokuBoard();

% Główna funkcja tworząca planszę
function createSudokuBoard()

    % Tworzenie macierzy przechowującej wartości pól na planszy
    sudoku = [7,9,2,4,5,1,8,6,3; 5,3,6,8,7,2,1,9,4; 1,4,8,3,9,6,2,5,7;
              9,6,4,1,8,3,5,7,2; 2,5,1,9,6,7,4,3,0; 8,7,3,2,4,5,6,1,0;
              3,1,9,6,2,8,7,4,0; 4,2,7,5,1,9,3,8,0; 6,8,5,7,3,4,9,2,0];

    
    % Liczba ruchów do wykonania
    moves = 81 - length(sudoku(sudoku>0));
    
    % Tworzenie okna gry
    fig = figure(Position=[200 200 500 500], MenuBar='none', ...
        ToolBar='none', NumberTitle='off', Name='Sudoku Game');
    
    % Tworzenie przycisków planszy
    sudoku_btn = zeros(9,9);
    for row = 1:9
        for col = 1:9
            x = 40 + (col-1)*40;
            y = 470 - row*40;
            number = sudoku(row,col);
            if number == 0
                sudoku_btn(row,col) = uicontrol(Style='pushbutton', String='', Position=[x y 40 40], ...
                    FontSize=16, FontWeight='bold', BackgroundColor=[1 1 1], Callback={@sudoku_btn_callback, row, col});
            else
                sudoku_btn(row,col) = uicontrol(Style='pushbutton', String=number, Position=[x y 40 40], ...
                    FontSize=16, FontWeight='bold', BackgroundColor=[1 1 1]);
            end
        end
    end
    
    % Tworzenie przycisków panelu sterowania
    num_btn = zeros(1,9);
    for num = 1:9
        x = 40 + (num-1)*40;
        y = 40;
        num_btn(num) = uicontrol(Style='togglebutton', String=num2str(num), Position=[x y 40 40], ...
            FontSize=16, FontWeight='bold', BackgroundColor=[1 1 1], Callback={@num_btn_callback, num});
    end

    % Linie oddzielające podkwadraty
    positions = [160 110 2 360; 280 110 2 360; 40 350 360 2; 40 230 360 2];
    for i = 1:4
        uicontrol(Style='text', Position=positions(i,:), BackgroundColor=[0 0 0]);
    end
    
    % Przyciski włączające gumkę oraz tryb notatek
    num_btn(10) = uicontrol(Style="togglebutton", String='X', Position=[400 40 40 40], FontSize=16, ...
        FontWeight='bold', BackgroundColor=[1 1 1], Callback= {@num_btn_callback, 0});
    note_mode_btn = uicontrol(Style="togglebutton", String='N', Position=[440 40 40 40], FontSize=16, ...
        FontWeight='bold', BackgroundColor=[1 1 1]);
    
    % Inicjalizacja uchwytów dla elementów interfejsu użytkownika
    handles.sudoku = sudoku;
    handles.current_num = 0;
    handles.moves = moves;
    handles.sudoku_btn = sudoku_btn;
    handles.num_btn = num_btn;
    handles.note_mode_btn = note_mode_btn;
    guidata(fig, handles);
end

% Funkcja sprawdzająca, czy można wstawić daną cyfrę w dane pole
function score = check_number(sudoku, num, row, col)
    if ismember(num, sudoku(row,:))
        score = false;
        return;
    end
    if ismember(num, sudoku(:,col))
        score = false;
        return;
    end

    % współrzędne lewego górnego wierzchołka kwadratu w którym leży
    % wskazane pole
    min_x = floor((row-1) / 3) * 3 + 1;
    min_y = floor((col-1) / 3) * 3 + 1;

    subsquare = sudoku(min_x:min_x+2, min_y:min_y+2);
    if ismember(num, subsquare)
        score = false;
        return;
    end
    score = true;
end

% Funkcja obsługująca kliknięcie przycisku planszy
function sudoku_btn_callback(src, ~, row, col)
    handles = guidata(src);
    current_num = handles.current_num;
    sudoku = handles.sudoku;
    moves = handles.moves;
    note_mode = handles.note_mode_btn.Value;
    prev_value = get(src, 'String');

    if current_num ~= 0
        if note_mode
            % Tryb notatek służy do notowania w pustych polach wartości,
            % jakie potencjalnie mogą się w nich znaleźć
            if isempty(prev_value) || get(src, 'FontSize') < 16
            new = num2str(current_num);
            if ismember(new, prev_value)
                new_value = prev_value(prev_value~=new);
            else
                new_value = [prev_value new];
            end
            new_value = sort(new_value);
            set(src, FontSize=8, FontWeight='normal', String=new_value)
            if length(new_value) > 6
                set(src, 'Tooltip', new_value(5:end));
            end
            end
        else
            if check_number(sudoku, current_num, row, col)
                sudoku(row, col) = current_num;
                if isempty(get(src, 'String')) || get(src, 'FontWeight') ~= "bold"
                    moves = moves - 1;
                end
                set(src, String=num2str(current_num), FontSize=16, FontWeight='bold');
                set(src, BackgroundColor=[0 1 0]);
            else
                errordlg('Błąd! Tutaj nie możesz wstawić tej cyfry.')
            end
        end
    else
        sudoku(row, col) = 0;
        set(src, String='', BackgroundColor=[1 1 1]);
        if ~note_mode
            moves = moves + 1;
        end
    end

    if moves == 0
        answer = questdlg('Gratulacje, wygrałeś Sudoku!', 'Wygrana', 'Restart', 'Zakończ', 'Restart');
        if strcmp(answer, 'Restart')
            close all;
            createSudokuBoard();
    elseif strcmp(answer, 'Zakończ')
        close all;
        end
    end

    handles.moves = moves;
    handles.sudoku = sudoku;
    guidata(src, handles);
end

% Funkcja obsługująca kliknięcie przycisku panelu sterowania
function num_btn_callback(src, ~, num)
    handles = guidata(src);
    set(handles.num_btn(), Value=0);
    handles.current_num = num;
    set(src, Value=1)
    guidata(src, handles);
end
