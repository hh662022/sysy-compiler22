
#include <cassert>
#include <cstdio>
#include <iostream>
#include <memory>
#include <string>
#include <sstream>
#include "koopa.h"
#include "AST.hpp"
#include "riskv.hpp"

using namespace std;

extern FILE *yyin;
extern int yyparse(unique_ptr<BaseAST> &ast);

int main(int argc, const char *argv[]) {
    assert(argc == 5);
    string mode = (string)argv[1];
    auto input = argv[2];
    auto output = argv[4];
    yyin = fopen(input, "r");
    assert(yyin);
    freopen(output, "w", stdout);
    unique_ptr<BaseAST> ast;
    auto ret = yyparse(ast);
    assert(!ret);
    if(mode == "-koopa"){
        ast->Dump(); 
    }
    else{// RISC-V
        stringstream ss;
        streambuf *buf = cout.rdbuf();
        cout.rdbuf (ss.rdbuf());
    ast->Dump();
        string str = ss.str();
        const char * IRStr = str.data();

        cout.rdbuf(buf);
        koopa_program_t program;
        koopa_error_code_t ret = koopa_parse_from_string(IRStr, &program);
        assert(ret == KOOPA_EC_SUCCESS); 
        koopa_raw_program_builder_t builder = koopa_new_raw_program_builder();
        koopa_raw_program_t raw = koopa_build_raw_program(builder, program);
        Visit(raw);

        koopa_delete_program(program);
        koopa_delete_raw_program_builder(builder);
    }

    return 0;
}
