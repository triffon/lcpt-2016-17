:- set_prolog_flag(occurs_check, true).

loves(john, mary).
loves(tom, mary).

/* loves(X, mary) => loves(john, X) */
loves(john, X) :- loves(X, mary).

/*
  x, y, z --- променливи
  app(M, N) -- апликация
  lam(X, M) --- абстракция
*/

i(lam(x, x)). % i := lam(x, x)
k(lam(x, lam(y, x))).
s(lam(x, lam(y, lam(z, app(app(x, z), app(y, z)))))).
w(lam(x, app(x, x))).
omega(app(W, W)) :- w(W).

/*
  alpha, beta --- типови променливи
  arrow(Rho, Sigma) --- функционален тип
*/

ti(arrow(alpha, alpha)).
tk(arrow(alpha, arrow(beta, alpha))).

/*
   типов контекст --- [[x,alpha],[y,arrow(alpha,alpha)], ...]
*/

/*
  types(Gamma, M, Tau) --- В Gamma термът M има тип Tau
*/

types(Gamma, X, Tau) :-
        atom(X), member([X,Tau], Gamma).
types(Gamma, app(M, N), Tau) :-
        types(Gamma, M, arrow(Rho, Tau)),
        types(Gamma, N, Rho).
types(Gamma, lam(X, M), arrow(Rho, Sigma)) :-
        types([[X,Rho]|Gamma], M, Sigma).

types(M, Tau) :- types([], M, Tau).