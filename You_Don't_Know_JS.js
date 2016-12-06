alert promp: get value from user
Immediately-Invoked Function Expression (IIFE) trong Javascript


IIFE là 1 pattern rất phổ biến trong Javascript. Pattern này đơn giản là tạo 1 function expression và thực thi function đó ngay lập tức. Pattern này đặc biệt hữu dụng khi bạn không muốn làm lộn xộn global namespace, bởi mọi biến hay function trong function đó đều không thể được truy cập từ bên ngoài.
(function() {
    var foo = "Hello world";
    console.log("IFFE")
})();
 
console.log( foo ); // undefined!

Clousre: ghi nho function 
function makeAdder(x) {
    // parameter `x` is an inner variable

    // inner function `add()` uses `x`, so
    // it has a "closure" over it
    function add(y) {
        return y + x;
    };

    return add;
}
var plusOne = makeAdder( 1 );

// `plusTen` gets a reference to the inner `add(..)`
// function with closure over the `x` parameter of
// the outer `makeAdder(..)`
var plusTen = makeAdder( 10 );

plusOne( 3 );       // 4  <-- 1 + 3
plusOne( 41 );      // 42 <-- 1 + 41

plusTen( 13 );      // 23 <-- 10 + 13

Javascript Module

Eval - so bad :
function foo(str, a) {
    eval( str ); // cheating!
    console.log( a, b );
}

var b = 2;

foo( "var b = 3;", 1 ); // 1, 3
lexical scope

With in Javascript:
var obj = {
    a: 1,
    b: 2,
    c: 3
};

// more "tedious" to repeat "obj"
obj.a = 2;
obj.b = 3;
obj.c = 4;

// "easier" short-hand
with (obj) {
    a = 3;
    b = 4;
    c = 5;
}
