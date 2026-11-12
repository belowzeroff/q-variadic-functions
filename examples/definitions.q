orders:([] Account:`a1`a1`a2`a2`a1; Desk:`d1``d2`d1`; Book:`k1```k2`; Symbol:`AAPL`MSFT`AAPL`MSFT`AAPL; Region:`US`EU`US`EU`EU; qty:100 200 300 400 500)
settings:([] k:`a`b; v:1 2)
tableName:{x}

getData:('[{$[1=count x;
                  [tbl:tableName $[x[0]=`Conf; `settings; `orders];
                   ?[tbl;();0b;()]];
               2=count x;
                  [cond:enlist (=;x[0];enlist x[1]);
                  if[x[0]=`Account;cond,:((^:;`Desk);(^:;`Book))];
                  ?[orders;cond;0b;()]];
               3=count x;
                  $[`all=x[2];?[orders;enlist (=;x[0];enlist x[1]);0b;()];
                     ?[orders;((=;x[0];enlist x[1]);(=;`Symbol;enlist x[2]));0b;()]];
               4=count x;
                  $[`all=x[2];?[orders;((=;x[0];enlist x[1]);(=;`Region;enlist x[3]));0b;()];
                     ?[orders;((=;x[0];enlist x[1]);(=;`Symbol;enlist x[2]);(=;`Region;enlist x[3]));0b;()]];
               "wrong amount of parameters"]
    };enlist])

getData2:('[{[a]
  n:count a;
  if[n>4;'"wrong amount of parameters"];
  if[n=1; :?[tableName $[a[0]=`Conf;`settings;`orders];();0b;()]];
  c:enlist(=;a 0;enlist a 1);
  / неявное правило оригинала: ровно два аргумента и Account -> только нераспределённые
  if[(n=2)&a[0]=`Account; c,:((^:;`Desk);(^:;`Book))];
  if[n>2; if[not`all=a 2; c,:enlist(=;`Symbol;enlist a 2)]];
  if[n>3; c,:enlist(=;`Region;enlist a 3)];
  ?[orders;c;0b;()]
  };enlist])

getData3:{[o]
  if[count bad:key[o] except `by`sym`region`unassigned; '"unknown keys: "," " sv string bad];
  c:();
  if[`by in key o; c,:enlist(=;o[`by]0;enlist o[`by]1)];
  if[1b~o`unassigned; c,:((^:;`Desk);(^:;`Book))];
  if[`sym in key o; c,:enlist(=;`Symbol;enlist o`sym)];
  if[`region in key o; c,:enlist(=;`Region;enlist o`region)];
  ?[orders;c;0b;()]}
