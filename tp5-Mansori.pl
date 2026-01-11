% ================================
%  TP5 - Systeme Expert M�dical
% ================================

:- dynamic reponse/2.

% -------------------------------
% Partie 1 : Base de connaissances
% -------------------------------

symptome(fievre).
symptome(toux).
symptome(mal_gorge).
symptome(fatigue).
symptome(courbatures).
symptome(mal_tete).
symptome(eternuements).
symptome(nez_qui_coule).

% -------------------------------
% Partie 2 : Interaction utilisateur
% -------------------------------

demander(S, Rep) :-
    write("Avez-vous "), write(S), write(" (o/n) ? "),
    read(Rep).

a_symptome(S) :-
    reponse(S, oui), !.

a_symptome(S) :-
    reponse(S, non), !, fail.

a_symptome(S) :-
    demander(S, R),
    ( R == o ->
        assert(reponse(S, oui))
    ;
        assert(reponse(S, non)), fail
    ).

% -------------------------------
% Partie 3 : R�gles des maladies
% -------------------------------

maladiei(grippe) :-
    a_symptome(fievre),
    a_symptome(courbatures),
    a_symptome(fatigue),
    a_symptome(toux).

maladiei(angine) :-
    a_symptome(mal_gorge),
    a_symptome(fievre).

maladiei(covid) :-
    a_symptome(fievre),
    a_symptome(toux),
    a_symptome(fatigue).

maladiei(allergie) :-
    a_symptome(eternuements),
    a_symptome(nez_qui_coule),
    \+ a_symptome(fievre).

% Liste des sympt�mes pour explication
symptomes_maladie(grippe, [fievre, courbatures, fatigue, toux]).
symptomes_maladie(angine, [mal_gorge, fievre]).
symptomes_maladie(covid, [fievre, toux, fatigue]).
symptomes_maladie(allergie, [eternuements, nez_qui_coule]).

% -------------------------------
% Moteur de diagnostic
% -------------------------------

trouver_maladies(L) :-
    findall(M, maladiei(M), L).

afficher_resultats([]) :-
    write("Aucune maladie trouv�e."), nl.

afficher_resultats(L) :-
    write("Vous pourriez avoir : "), nl,
    forall(member(M, L), (write("- "), write(M), nl)).

expliquer(Maladie) :-
    symptomes_maladie(Maladie, Liste),
    write("Pourquoi : "), nl,
    forall(
        (member(S, Liste), reponse(S, oui)),
        (write(" - "), write(S), nl)
    ).

% -------------------------------
% Programme principal
% -------------------------------

expert :-
    retractall(reponse(_, _)),
    trouver_maladies(Liste),
    afficher_resultats(Liste),
    nl,
    forall(member(M, Liste), (write(">> "), write(M), nl, expliquer(M), nl)).
