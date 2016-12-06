alert promp: get value from user
Immediately-Invoked Function Expression (IIFE) trong Javascript


IIFE là 1 pattern rất phổ biến trong Javascript. Pattern này đơn giản là tạo 1 function expression và thực thi function đó ngay lập tức. Pattern này đặc biệt hữu dụng khi bạn không muốn làm lộn xộn global namespace, bởi mọi biến hay function trong function đó đều không thể được truy cập từ bên ngoài.
(function() {
    var foo = "Hello world";
    console.log("IFFE")
})();
 
console.log( foo ); // undefined!
