    
    //home
    $(document).on({
        "touchstart, click": function (e) {
               window.location.href = "index.html";
            }
    }, "#top, #top-mobile");


    //scroll-to
    $(document).on({
        "touchstart, click": function (e) {
            var link = $(this).data('link'),
                offsetTop = $(link).offset().top + 50;
                $('html, body').animate({scrollTop: offsetTop}, 500);
                e.preventDefault();
            }
    }, ".scroll");

    //menu
    $(document).on({ 
        "touchstart, click": function (e) { 
            var div = '#'+$(this).data('div')+'-hidden';

                $(this).toggleClass('clicked');
                if( $(this).data('div') == 'menu-login'){
                    $('.menu-list').removeClass('clicked');
                    $('#menu-list-hidden').slideUp(300);
                } 
                else if (  $(this).data('div') == 'menu-list' ) {
                    $('.menu-login').removeClass('clicked');
                    $('#menu-login-hidden').slideUp(300);
                }

                if( $(this).hasClass('clicked') ) {
                    $(div).slideDown(300);
                    $( "#top" ).animate({'opacity': 0.2}, 300);
                } else {
                    $(div).slideUp(300);
                    $( "#top" ).animate({'opacity': 1}, 300);
                    setTimeout(function(){
                        $('.login-select').css({'display':'block'});
                        $('.login-m').css({'display':'none'});
                    }, 300);
                }
        } 
    }, '.menu-list, .menu-login');


    //login types on choose
    $(document).on({ 
        "touchstart, click": function (e) { 
            setTimeout(function(){
                $('.login-select').css({'display':'none'});
                $('.login-m').css({'display':'block'});
            }, 300);
            e.preventDefault();
        } 
    }, '#m-login');

    $(window).load(function(){
        //init
        $('.section-2').masonry({
            itemSelector: '.item'
        });

        $(document).ready(function(){
            skrollr.init({
                forceHeight: false /*important !*/
            });
        });
    });
    