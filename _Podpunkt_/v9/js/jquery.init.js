
    //scroll-to
    $(document).on({
        "touchstart, click": function (e) {
            var link = $(this).data('link'),
                offsetTop = $(link).offset().top;
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
                }
        } 
    }, '.menu-list, .menu-login');


    //login types on choose
    $(document).on({ 
        "touchstart, click": function (e) { 
            $('.login-select').animate({'opacity': 0, 'height': 0}, 200);
            setTimeout(function(){
                $('.login-select').css({'display':'none'});
                $('.login-m').css({'display':'block'});
            }, 300);
            e.preventDefault();
        } 
    }, '#m-login');

    $(document).on({ 
        "touchstart, click": function (e) { 
            $('.login-m').css({'display':'none'});
            $('.login-select').css({'display':'block'});
            setTimeout(function(){
                $('.login-select').animate({'opacity': 1, 'height': 'auto'}, 200);
            }, 300);
            e.preventDefault();
        } 
    }, '#m-login-hide');

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
    