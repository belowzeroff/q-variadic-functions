/ Safe, repeatable examples for article.md. Run from this directory.
\l definitions.q

f:('[{x};enlist])
cnt:('[{count x};enlist])
add:('[{sum x};enlist])
timed:{[fn] '[{[fn;a] s:.z.p; r:fn . a; -1 "took ",string .z.p-s; r}[fn];enlist]}

assert:{[ok;label] if[not ok; -1 "FAIL: ",label; exit 1]; -1 "ok: ",label}

/ Variadic composition forwards up to 20 arguments.
assert[cnt[1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20]~20;"cnt accepts 20 arguments"]
/ Calling with no explicit args passes one null argument via enlist.
assert[(f[])~enlist(::);"f[] is a one-item null list"]
/ Projection fixes remaining argument positions.
p:f[10;]
assert[(p 5)~10 5;"variadic projection"]
assert[(.[p;5 6;{x}])~"rank";"projection rejects extra argument"]
/ This dot call spreads nine args and triggers rank; do not run it unguarded.
dotNineFails:.Q.trp[{f . til 9};();{[e;b] e~"rank"}]
assert[dotNineFails;"f . til 9 is caught as rank"]

/ Applying a variadic function with Each to two lists is pairwise.
assert[(add'[1 2;10 20])~11 22;"each with two lists"]
assert[(add/[1 2 3])~1 2 3;"variadic add Over is not a fold"]
assert[(add/[0;1 2 3])~1 2 3;"zero applications"]
assert[({[a;b] add[a;b]}/[1 2 3])~6;"binary wrapper fold"]
assert[({[a;b] add[a;b]}/[0;1 2 3])~6;"seeded binary wrapper fold"]
assert[(cnt each (1 2;3 4 5))~1 1;"each passes one argument"]
assert[(@[{1 add\: 1 2 3};0;{x}])~"rank";"each-left rank"]
/ Unbounded f Over/Scan is excluded (historical crash).

/ getData and getData2: eight valid input shapes, compare returned tables structurally.
assert[(getData[`Conf])~(getData2[`Conf]);"getData/getData2 Conf"]
assert[(getData[`orders])~(getData2[`orders]);"getData/getData2 all orders"]
assert[(getData[`Account;`a1])~(getData2[`Account;`a1]);"getData/getData2 unassigned Account"]
assert[(getData[`Symbol;`AAPL])~(getData2[`Symbol;`AAPL]);"getData/getData2 Symbol"]
assert[(getData[`Account;`a1;`AAPL])~(getData2[`Account;`a1;`AAPL]);"getData/getData2 Account and Symbol"]
assert[(getData[`Account;`a1;`all])~(getData2[`Account;`a1;`all]);"getData/getData2 all Symbols"]
assert[(getData[`Account;`a1;`AAPL;`EU])~(getData2[`Account;`a1;`AAPL;`EU]);"getData/getData2 Account/Symbol/Region"]
assert[(getData[`Account;`a1;`all;`EU])~(getData2[`Account;`a1;`all;`EU]);"getData/getData2 Account/all/Region"]

/ Compare full tables for six dictionary mappings.
assert[(getData[`Account;`a1])~getData3[`by`unassigned!(`Account`a1;1b)];"dictionary unassigned"]
assert[(getData[`Account;`a1;`all])~getData3[enlist[`by]!enlist`Account`a1];"dictionary all symbols"]
assert[(getData[`Account;`a1;`AAPL])~getData3[`by`sym!(`Account`a1;`AAPL)];"dictionary symbol"]
assert[(getData[`Account;`a1;`AAPL;`EU])~getData3[`by`sym`region!(`Account`a1;`AAPL;`EU)];"dictionary symbol and region"]
assert[(getData[`Account;`a1;`all;`EU])~getData3[`by`region!(`Account`a1;`EU)];"dictionary region"]
assert[(getData[`Symbol;`AAPL])~getData3[enlist[`by]!enlist`Symbol`AAPL];"dictionary by Symbol"]
assert[(count getData[`Account;`a1])~2;"two arguments return two rows"]
assert[(count getData[`Account;`a1;`all])~3;"third argument changes row count"]

/ Timing output is nondeterministic; only verify the wrapped result.
tw:timed[{x+y}]
assert[tw[2;3]~5;"timed wrapper returns function result"]
assert[(timed[{x*x}][3])~9;"timed unary"]
assert[(timed[{x+y+z}][1;2;3])~6;"timed ternary"]
-1 "All article examples passed."
exit 0
