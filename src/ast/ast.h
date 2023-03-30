#pragma once


namespace em::ast {

    enum NodeKind {
        Numeric, 
        Binary,
    };

    struct Expr {
        em::ast::NodeKind kind;
        virtual void node () = 0;
    };


}