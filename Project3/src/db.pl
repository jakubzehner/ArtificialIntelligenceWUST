% Drukarka http://h10032.www1.hp.com/ctg/Manual/bpl11081
% Siec semantyczna

sklada_sie_z(drukarka, Podzespol) :- podzespol(Podzespol).

podzespol(kontrolki).
podzespol(kontrolka_zolta).
podzespol(kontrolka_zielona).
podzespol(podajnik).
podzespol(podporka_dlugich_materialow).
podzespol(boczne_prowadnice).
podzespol(lewa_prowadnica).
podzespol(prawa_prowadnica).
podzespol(drzwiczki_gniazda_kasety_z_tonerem).
podzespol(pojemnik_wyjciowy).
podzespol(zwalniacze_docisku).
podzespol(zwalniacz_lewy).
podzespol(zwalniacz_prawy).
podzespol(sciezka_wydruku).
podzespol(gniazdo_zasilania).
podzespol(port_usb).
podzespol(przycisk_testu_silnika).

sklada_sie_na(Element, Czesc) :- zlozony_z(Czesc, Element).

zlozony_z(kontrolki, kontrolka_zielona).
zlozony_z(kontrolki, kontrolka_zolta).
zlozony_z(boczne_prowadnice, lewa_prowadnica).
zlozony_z(boczne_prowadnice, prawa_prowadnica).
zlozony_z(zwalniacze_docisku, zwalniacz_prawy).
zlozony_z(zwalniacze_docisku, zwalniacz_lewy).

funkcja_obslugiwana_przez(Funkcja, Czesc) :- funkcja(Czesc, Funkcja).

funkcja(Czesc, Funkcja) :- sklada_sie_na(Element, Czesc), funkcja(Element, Funkcja).

funkcja(drukarka, drukowanie).
funkcja(drukarka, skanowanie).
funkcja(drukarka, kopiowanie).
funkcja(kontrolka_zielona, sygnalizacja).
funkcja(kontrolka_zolta, sygnalizacja).
funkcja(kontrolka_zielona, gotowe).
funkcja(kontrolka_zolta, uwaga).
funkcja(podajnik, podawanie_papieru).
funkcja(lewa_prowadnica, prowadzenie_papieru).
funkcja(prawa_prowadnica, prowadzenie_papieru).
funkcja(pojemnik_wyjciowy, przechowywanie_wydruku).
funkcja(pojemnik_wyjciowy, wyjscie_wydruku).
funkcja(sciezka_wydruku, wyjscie_wydruku).
funkcja(drzwiczki_gniazda_kasety_z_tonerem, ochrona_tonera).
funkcja(przycisk_testu_silnika, test_silnika).
funkcja(port_usb, podlaczenie_do_komputera).
funkcja(gniazdo_zasilania, podlaczenie_do_zasilania).

diagnoza(Problem, Przyczyna) :-
    problem(Problem),
    przyczyna(Problem, Przyczyna).

znajdz_rozwiazanie(Problem, Przyczyna, Rozwiazanie, Powiazana_czesc) :-
    diagnoza(Problem, Przyczyna),
    rozwiazanie(Przyczyna, Rozwiazanie, Powiazana_czesc).

problem(drukarka_nie_reaguje).
problem(material_sie_zakleszczyl).
problem(druk_wykrzywiony).
problem(drukarka_pobiera_wiele_kartek).
problem(drukarka_nie_pobiera_materialow).
problem(nieczytelny_tekst).
problem(bledny_tekst).
problem(niepelny_tekst).
problem(zla_jakosc_grafiki).

przyczyna(drukarka_nie_reaguje, nie_podlaczona_do_pradu).
przyczyna(drukarka_nie_reaguje, nie_podlaczona_do_komputera).
przyczyna(material_sie_zakleszczyl, nieprawidlowe_parametry_materialu).
przyczyna(material_sie_zakleszczyl, material_pomarszony_lub_pozaginany).
przyczyna(material_sie_zakleszczyl, sciezka_wydruku_brudna).
przyczyna(material_sie_zakleszczyl, zwalniacze_docisku_nie_zamkniete).
przyczyna(druk_wykrzywiony, prowadnice_zle_ustawione).
przyczyna(drukarka_pobiera_wiele_kartek, podajnik_przepelniony).
przyczyna(drukarka_pobiera_wiele_kartek, material_pomarszony_lub_pozaginany).
przyczyna(drukarka_pobiera_wiele_kartek, plytka_rozdzielacza_zuzyta).
przyczyna(drukarka_nie_pobiera_materialow, podajnik_brudny).
przyczyna(drukarka_nie_pobiera_materialow, podajnik_uszkodzony).
przyczyna(nieczytelny_tekst, kabel_usb_uszkodzony).
przyczyna(nieczytelny_tekst, nieprawidlowy_sterownik).
przyczyna(nieczytelny_tekst, problem_z_programem).
przyczyna(bledny_tekst, kabel_usb_uszkodzony).
przyczyna(bledny_tekst, nieprawidlowy_sterownik).
przyczyna(bledny_tekst, problem_z_programem).
przyczyna(niepelny_tekst, kabel_usb_uszkodzony).
przyczyna(niepelny_tekst, nieprawidlowy_sterownik).
przyczyna(niepelny_tekst, problem_z_programem).
przyczyna(zla_jakosc_grafiki, problem_z_programem).
przyczyna(zla_jakosc_grafiki, zle_ustawienia).

rozwiazanie(nie_podlaczona_do_pradu,'Podlacz drukarke do pradu',[gniazdo_zasilania]).
rozwiazanie(nie_podlaczona_do_komputera,'Podlacz drukarke do komputera',[port_usb]).
rozwiazanie(nieprawidlowe_parametry_materialu,'Uzyj materialu o prawidlowych parametrach',[]).
rozwiazanie(material_pomarszony_lub_pozaginany,'Uzyj nieuszkodzonego materialu',[]).
rozwiazanie(sciezka_wydruku_brudna,'Wyczysc sciezke wydruku drukarki',[sciezka_wydruku]).
rozwiazanie(zwalniacze_docisku_nie_zamkniete,'Zamknij i otworz ponownie drzwiczki, aby upewnic sie, ze zwalniacze docisku sa zamkniete', [drzwiczki_gniazda_kasety_z_tonerem, zwalniacze_docisku, zwalniacz_prawy, zwalniacz_lewy]).
rozwiazanie(prowadnice_zle_ustawione,'Ustaw prowadnice w pozycjach odpowiadajacych szerokosci i dlugosci uzywanych materialow',[boczne_prowadnice, lewa_prowadnica, prawa_prowadnica]).
rozwiazanie(podajnik_przepelniony,'Wyjmij czesc kartek z podajnika',[podajnik]).
rozwiazanie(plytka_rozdzielacza_zuzyta,'Wymien plytke rozdzielacza',[podajnik]).
rozwiazanie(podajnik_brudny,'Wyczysc podajnik',[podajnik]).
rozwiazanie(podajnik_uszkodzony,'Wymien podajnik',[podajnik]).
rozwiazanie(kabel_usb_uszkodzony,'Wymien kabel USB',[port_usb]).
rozwiazanie(nieprawidlowy_sterownik,'Zainstaluj poprawny sterownik drukarki',[]).
rozwiazanie(problem_z_programem,'Sprobuj wydrukowac za pomoca innego programu',[]).
rozwiazanie(zle_ustawienia,'Sprawdz rozdzielczosc drukowania w ustawieniach wydruku',[]).
