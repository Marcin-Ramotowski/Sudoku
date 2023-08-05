% Aplikacja do gry w sudoku
% Marcin Ramotowski
% Program wzorowany na aplikacji Sudoku.com - zagadki liczbowe
% studia EasyBrain dostępnej w GooglePlay Store

createSudokuBoard();

function sudoku = getSudokuFromApi(options)
    % Ustawienie parametrów żądania
    difficulty = questdlg('Wybierz poziom trudności:', 'Sudoku', 'Easy', 'Medium', 'Hard', 'Easy');
    seed = ''; % np. '1234567890'
    url = '/sudoku/generate';
    if ~isempty(seed)
        url = [url '?seed=' seed];
    elseif ~isempty(difficulty)
        url = [url '?difficulty=' difficulty];
    end
    % Wysłanie żądania GET i odbiór odpowiedzi
    response = webread(['https://sudoku-generator1.p.rapidapi.com' url], options);
    sudoku = response.puzzle;
end

function solution = getSolutionFromApi(puzzle, options)
    % Ustawienie parametrów żądania
    url = '/sudoku/solve';
    if ~isempty(puzzle)
        url = [url '?puzzle=' puzzle];
    end
    % Wysłanie żądania GET i odbiór odpowiedzi
    response = webread(['https://sudoku-generator1.p.rapidapi.com' url], options);
    solution = response.solution;
end


% Główna funkcja tworząca planszę
function createSudokuBoard()
    
    % Odczyt danych z pliku .env
    config = readtable('.env', 'Delimiter', '=', ...
        'ReadVariableNames', false, 'FileType', 'text');
    content_type = config.Var2(1);
    api_key = config.Var2(2);
    api_host = config.Var2(3);

    % Ustawienie nagłówków żądania
    options = weboptions("HeaderFields", ...
    ['content-type', content_type; ...
    'X-RapidAPI-Key',api_key; ...
    'X-RapidAPI-Host',api_host]);

    % Odbiór macierzy sudoku oraz jego rozwiązania z API
    sudoku = getSudokuFromApi(options);
    solution = getSolutionFromApi(sudoku, options);
    sudoku = reshape(sudoku, 9, []).';
    solution = reshape(solution, 9, []).';
    
    % Liczba ruchów do wykonania
    moves = 81 - length(sudoku(sudoku~='.'));
    
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
            if number == '.'
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
        num_btn(num) = uicontrol(Style='togglebutton', String=num, Position=[x y 40 40], ...
            FontSize=16, FontWeight='bold', BackgroundColor=[1 1 1], Callback={@num_btn_callback, num});
    end

    % Linie oddzielające podkwadraty
    positions = [160 110 2 360; 280 110 2 360; 40 350 360 2; 40 230 360 2];
    for i = 1:4
        uicontrol(Style='text', Position=positions(i,:), BackgroundColor=[0 0 0]);
    end
    
    % Przyciski włączające gumkę oraz tryb notatek
    note_mode_btn = uicontrol(Style="togglebutton", String='N', Position=[400 40 40 40], FontSize=16, ...
        FontWeight='bold', BackgroundColor=[1 1 1]);

    % Wyświetlanie liczby pomyłek oraz limitu
    uicontrol(Style="text", String="Liczba pomyłek:", Position=[400 270 80 120], FontSize=9);
    fails_counter = uicontrol(Style="text", String=0, Position=[418 318 40 40], FontSize=9);
    fails_limit = 3;
    uicontrol(Style="text", String="Limit pomyłek:", Position=[400 170 80 120], FontSize=9);
    uicontrol(Style="text", String=fails_limit, Position=[418 218 40 40], FontSize=9);
    
    % Inicjalizacja uchwytów dla elementów interfejsu użytkownika
    handles.sudoku = sudoku;
    handles.solution = solution;
    handles.current_num = 0;
    handles.moves = moves;
    handles.sudoku_btn = sudoku_btn;
    handles.num_btn = num_btn;
    handles.note_mode_btn = note_mode_btn;
    handles.fails_counter = fails_counter;
    handles.fails_limit = fails_limit;
    guidata(fig, handles);
end

% Funkcja sprawdzająca, czy można wstawić daną cyfrę w dane pole
function score = check_number(sudoku, solution, num, row, col)
    if sudoku(row, col) ~= '.'
        score = false;
        return;
    end
    if solution(row, col) ~= num2str(num)
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
    solution = handles.solution;
    moves = handles.moves;
    note_mode = handles.note_mode_btn.Value;
    fails_number = str2num(get(handles.fails_counter, 'String'));
    prev_value = get(src, 'String');

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
        if check_number(sudoku, solution, current_num, row, col)
            sudoku(row, col) = current_num;
            if isempty(get(src, 'String')) || get(src, 'FontWeight') ~= "bold"
                moves = moves - 1;
            end
            set(src, String=num2str(current_num), FontSize=16, FontWeight='bold');
            set(src, BackgroundColor=[0 1 0]);
        else
            fails_number = fails_number + 1;
            set(handles.fails_counter, String=fails_number)
            if fails_number <= handles.fails_limit
                errordlg('Błąd! Tutaj nie możesz wstawić tej cyfry.')
            end
        end
    end

    if moves == 0 || fails_number > handles.fails_limit
        if moves == 0
            message = 'Gratulacje, rozwiązałeś Sudoku!';
            title = 'Wygrana';
        else
            message = 'Niestety, przegrałeś.';
            title = 'Przegrana';
        end
        answer = questdlg(message, title, 'Restart', 'Zakończ', 'Restart');
        if strcmp(answer, 'Restart')
            close;
            createSudokuBoard();
            return;
    elseif strcmp(answer, 'Zakończ')
        close;
        return;
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