/*
  x, y, z --- променливи
  app(M, N) -- апликация
  lam(X, M) --- абстракция
  alpha, beta --- типови променливи
  arrow(Rho, Sigma) --- функционален тип
  типов контекст --- [[x,alpha],[y,arrow(alpha,alpha)], ...]
  types(Gamma, M, Tau) --- В Gamma термът M има тип Tau
  types_many(Gamma, [M1, M2, ..., Mn], [Tau1, Tau2, ..., Taun])
*/

ti(arrow(alpha, alpha)).
tk(arrow(alpha, arrow(beta, alpha))).
ts(arrow(
         arrow(alpha, arrow(beta, gamma)),
         arrow(
               arrow(alpha, beta),
               arrow(alpha,
                     gamma)))).

tu(arrow(arrow(alpha, alpha), alpha)).
tv(arrow(
         alpha,
         arrow(
               arrow(alpha, gamma),
               arrow(
                     arrow(gamma, alpha),
                     alpha)))).

/* argtypes(Rhos, Tau, Sigma) <--->
   Sigma = Rho1 => Rho2 => ... Rhon => Tau */

argtypes([], Tau, Tau).  /* може и :- atom(Tau) */
argtypes([Rho|Rhos], Tau, arrow(Rho, Sigma)) :-
        argtypes(Rhos, Tau, Sigma).

/*
    types_many(Gamma, [M1, M2, ..., Mn], [Tau1, Tau2, ..., Taun] <---->
           types(Gamma, N1, Rho1),
           types(Gamma, N2, Rho2),
           ...
           types(Gamma, Nn, Rhon)
*/  

types_many(_, [], [], _).
types_many(Gamma, [M | Ms], [Tau | Taus], Visited) :-
        types(Gamma, M, Tau, Visited),
        types_many(Gamma, Ms, Taus, Visited).

/*
   argterms(X, Ns, M) <--->  M = ( X ) N1 N2 ... Nn
                      <--->  M = ( X N1 ) N2 ... Nn
*/

argterms(X, [], X).
argterms(X, [N | Ns], M) :-
        argterms(app(X, N), Ns, M).

/* Visited съдържа само типови променливи, които вече
   сме обходили */

types(Gamma, lam(X, M), arrow(Rho, Sigma), Visited) :-
        types([[X, Rho] | Gamma], M, Sigma, Visited).
             
types(Gamma, M, Tau, Visited) :-
        not(member(Tau, Visited)),
        member([X, Sigma], Gamma),
        /* Sigma = Rho1 => Rho2 => ... Rhon => Tau */
        argtypes(Rhos, Tau, Sigma),
        /*
           types(Gamma, N1, Rho1),
           types(Gamma, N2, Rho2),
           ...
           types(Gamma, Nn, Rhon),
        */
        types_many(Gamma, Ns, Rhos, [Tau | Visited]),
        /* M = X N1 N2 ... Nn */
        argterms(X, Ns, M).

types(M, Tau) :- types([], M, Tau, []).