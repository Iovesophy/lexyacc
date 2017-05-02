/* yacc
 * compile process on second faze explain sentence analysis.
 * sentence analysis usage
 * we can sepalate to top-down and bottom-up
 * 1,recursive top-down is tree from native to down.
 * sentence rule docile reration analysis usage.
 * recursive top-down analysis usage is rerated each recursive processing about sentence rule on each nonend symbol.
 * We analysis of sentence by gathering procedure.
 * analysis program is witting of sentence rule.
 * when operator * and + are  exppression below,itself re defined from left use.
 * if as it is change code,analysis into infinity loop.
 * 
 * sentence rule A.
 * <formula> ::= <formula> + <item>  | <item>
 * <item>    ::= <item> * <variable> | <variable>
 * 
 * As the following changeing eqaul sentence rule , you can avoidance infinity loop problame.
 * this here {X} is expression X line up that's all 0.
 * 
 * sentence rule B.
 * <formula> ::= <item> { + <item> } (1)
 * <item> ::= <variable> { * <variable> } (2)
 * <variable> ::= a|b|c (3)
 * 
 * this here indicate sentence rule A. for your reference.
 * none changeing from rule A to rule B, at first consider rule B is good.
 * for exapmle when B * C + D / E , "*,/" are high priority by "+,-" so, we lump B*C and D/E, it can be understood (B*C) + (D/E).
 * To top-down can expression <formula> ::= <item> + <item>.
 * -- if exist *,/
 * but + , - is none, it must expression <formula> ::= <item>
 *
 * -- if + exist two, it must expression <formula> ::= <item> + <item> + <item>
 *
 * -- it must expression sentence rule B (1) because of"+" number is that's all 0.
 * sentence rule write from row operator priority. so, it can easy understand sentence rule B (2)!
 * it is binary operation ,so +and* are same formation.
 * <variable> haigh operator priority change writting due to not binary operetion.
 * 1,initial preocessing of token a : start procedure from <formula>. Immediately change procedure to <item>,when start <item>,immediately change procedure to <variable>,and this here matching token a.
 * end of call analysis, back to <variable> procedure.
 * 2,processing of token + : processing of <formula> go to <item> +
 * 3,processing of token b : go to <variable> to b from <item>.
 * 4,processing of token * : when back to <variable> , next token is * so,continue precessing of <item> and go to <variable> *.
 * 5,processing of token c : go to c from <variable>. so token finish ,exit processing of <item> and back to initial call <formula> . complete analysis.
 * normal compila, it make tree data from this analysis process and analysis later use to make code ,faze in parallel mean analysis. 
 * so isn't need make tree data.
 * 
 * bottom-up analysis
 * sentence analysis tree is starting to 
