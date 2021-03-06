JsOsaDAS1.001.00bplist00�Vscripto� f u n c t i o n   r u n ( )   { 
     i f   ( ! i s P h o t o s A p p R u n n i n g ( ) )   { 
         w a r n I f P h o t o s A p p I s C l o s e d ( ) ; 
         r e t u r n ; 
     } 
 
     v a r   a p p   =   g e t P h o t o s A p p ( ) ; 
 
     i f   ( ! v e r i f y P h o t o S e l e c t i o n ( a p p ) )   { 
         r e t u r n ; 
     } 
 
     v a r   s e l e c t e d P h o t o   =   g e t S e l e c t e d P h o t o ( a p p ) ; 
 
     i f   ( s e l e c t e d P h o t o   = =   n u l l )   { 
         a p p . d i s p l a y A l e r t ( 
             " F a i l e d   t o   f i n d   s e l e c t e d   p h o t o . \ n \ n T h i s   m i g h t   h a p p e n   i f   y o u   s e l e c t   t h e   p h o t o   i n   a   S m a r t   A l b u m .   T r y   s e l e c t i n g   t h e   p h o t o   w h i l e   i n   a   r e g u l a r   a l b u m   ( e . g   r i g h t   c l i c k   p h o t o   >   A d d   t o   >   N e w   A l b u m ) . " 
         ) ; 
         r e t u r n ; 
     } 
 
     v a r   a l b u m s   =   g e t A l b u m s F l a t t e n e d ( a p p ) ; 
     v a r   m a t c h i n g A l b u m s   =   f i n d A l b u m s F o r P h o t o ( s e l e c t e d P h o t o . i d ( ) ,   a l b u m s ) ; 
     d i s p l a y R e s u l t s ( s e l e c t e d P h o t o ,   m a t c h i n g A l b u m s ,   a p p ) ; 
 } 
 
 f u n c t i o n   d i s p l a y R e s u l t s ( p h o t o ,   a l b u m s ,   a p p )   { 
     i f   ( a l b u m s . l e n g t h )   { 
         v a r   n a m e s   =   a l b u m s . m a p ( ( a l b u m )   = >   { 
             v a r   p a r t s   =   g e t F u l l A l b u m N a m e S t r u c t u r e ( a l b u m ) ; 
             v a r   n a m e   =   p a r t s . j o i n ( "   >   " ) ; 
             r e t u r n   "   "   "   +   n a m e ; 
         } ) ; 
 
         v a r   t e x t   =   ` P h o t o   $ { p h o t o . f i l e n a m e ( ) }   s i t s   i n   t h e s e   a l b u m s \ n $ { n a m e s . j o i n ( 
             " \ n " 
         ) } ` ; 
         a p p . d i s p l a y A l e r t ( t e x t ) ; 
     }   e l s e   { 
         a p p . d i s p l a y A l e r t ( " P h o t o   i s   i n   n o   a l b u m " ) ; 
     } 
 } 
 
 f u n c t i o n   f i n d A l b u m s F o r P h o t o ( i d ,   a l b u m s )   { 
     v a r   f i l t e r e d   =   [ ] ; 
 
     f o r   ( v a r   j   =   0 ;   j   <   a l b u m s . l e n g t h ;   j + + )   { 
         v a r   a l b u m   =   a l b u m s [ j ] ; 
 
         v a r   m a t c h e s   =   a l b u m . m e d i a I t e m s . w h o s e ( {   i d :   {   " = " :   i d   }   } ) ; 
 
         i f   ( m a t c h e s . l e n g t h )   { 
             f i l t e r e d . p u s h ( a l b u m ) ; 
         } 
     } 
 
     r e t u r n   f i l t e r e d ; 
 } 
 
 f u n c t i o n   v e r i f y P h o t o S e l e c t i o n ( a p p )   { 
     / /   A p a r t   f r o m   " r e g u l a r "   s e l e c t i o n   o f   p h o t o s ,   a p p . s e l e c t i o n ( ) . l e n g t h   a l s o   s h o w s 
     / /   t h e   f o l l o w i n g   b e h a v i o r : 
     / /   L i b r a r y   >   P h o t o s   ( i . e .   a l l   p h o t o s )   s e l e c t e d :   L e n g t h   i s   0 
     / /   A n y   a l b u m   s e l e c t e d :   L e n g t h   e q u a l s   t h e   n u m b e r   o f   p h o t o s   i n   t h e   a l b u m 
 
     v a r   s e l e c t i o n   =   a p p . s e l e c t i o n ( ) ; 
 
     i f   ( s e l e c t i o n . l e n g t h   = =   1 )   { 
         v a r   s e l e c t e d P h o t o   =   g e t S e l e c t e d P h o t o ( a p p ) ; 
 
         i f   ( s e l e c t e d P h o t o   = =   n u l l )   { 
             a p p . d i s p l a y A l e r t ( 
                 " F a i l e d   t o   f i n d   s e l e c t e d   p h o t o . \ n \ n T h i s   m i g h t   h a p p e n   i f   y o u   s e l e c t   t h e   p h o t o   w h i l e   v i e w i n g   a   S m a r t   A l b u m .   T r y   s e l e c t i n g   t h e   p h o t o   w h i l e   i n   a   r e g u l a r   a l b u m   ( e . g   r i g h t   c l i c k   p h o t o   >   A d d   t o   >   N e w   A l b u m ) . " 
             ) ; 
             r e t u r n   f a l s e ; 
         } 
 
         r e t u r n   t r u e ; 
     }   e l s e   i f   ( s e l e c t i o n . l e n g t h   = =   0 )   { 
         a p p . d i s p l a y A l e r t ( " P l e a s e   s e l e c t   a   p h o t o   i n   t h e   P h o t o s   a p p " ) ; 
         r e t u r n   f a l s e ; 
     }   e l s e   { 
         a p p . d i s p l a y A l e r t ( " P l e a s e   s e l e c t   a   s i n g l e   p h o t o   i n   t h e   P h o t o s   a p p " ) ; 
         r e t u r n   f a l s e ; 
     } 
 } 
 
 f u n c t i o n   g e t S e l e c t e d P h o t o ( a p p )   { 
     t r y   { 
         v a r   p h o t o   =   a p p . s e l e c t i o n ( ) [ 0 ] ; 
         p h o t o . i d ( ) ;   / /   T h i s   b l o w s   u p   i f   s e l e c t i n g   p h o t o   w h i l e   i n   a   S m a r t   A l b u m 
         r e t u r n   p h o t o ; 
     }   c a t c h   ( e )   { 
         r e t u r n   n u l l ; 
     } 
 } 
 
 f u n c t i o n   g e t A l b u m s F l a t t e n e d ( a p p )   { 
     r e t u r n   f i n d A l l A l b u m s ( a p p ) ; 
 } 
 
 f u n c t i o n   f i n d A l l A l b u m s ( n o d e )   { 
     / /       l o g ( ` P R O C E S S I N G   n o d e :   $ { n o d e . n a m e ( ) } ,   i t   h a s   $ { n o d e . f o l d e r s . l e n g t h } $   s u b f o l d e r s ` ) ; 
     v a r   a l b u m s   =   [ ] ; 
 
     f o r   ( v a r   i   =   0 ;   i   <   n o d e . f o l d e r s . l e n g t h ;   i + + )   { 
         v a r   f o l d e r   =   n o d e . f o l d e r s [ i ] ; 
 
         v a r   s u b a l b u m s   =   f i n d A l l A l b u m s ( f o l d e r ) ; 
         a l b u m s   =   a l b u m s . c o n c a t ( s u b a l b u m s ) ; 
     } 
 
     r e t u r n   a l b u m s . c o n c a t ( n o d e . a l b u m s ( ) ) ; 
 } 
 
 f u n c t i o n   g e t F u l l A l b u m N a m e S t r u c t u r e ( a l b u m )   { 
     v a r   p a r t s   =   [ a l b u m . n a m e ( ) ] ; 
 
     t r y   { 
         w h i l e   ( a l b u m . p a r e n t )   { 
             a l b u m   =   a l b u m . p a r e n t ; 
             p a r t s . u n s h i f t ( a l b u m . n a m e ( ) ) ; 
         } 
     }   c a t c h   { 
         / /   N o   o p . 
         / /   U n f o r t u n a t e l y   I   c o u l d n ' t   f i n d   a   c l e a n   w a y   t o   d e t e r m i n e   i f   c u r r e n t   n o d e 
         / /   i s   t h e   t o p m o s t   n o d e   o r   n o t   ( i . e .   t h e   ' a p p l i c a t i o n   o b j e c t ' ) .   T h e   t o p m o s t   n o d e 
         / /   i d e n t i f i e s   a s   a   ' f o l d e r '   c l a s s   ( O b j e c t S p e c i f i e r . c l a s s O f ) ,   b u t   f a i l s   o n   n a m e ( ) 
         / /   a n d   i d ( ) . 
     } 
 
     r e t u r n   p a r t s ; 
 } 
 
 f u n c t i o n   i s P h o t o s A p p R u n n i n g ( )   { 
     r e t u r n   A p p l i c a t i o n ( " P h o t o s " ) . r u n n i n g ( ) ; 
 } 
 
 f u n c t i o n   w a r n I f P h o t o s A p p I s C l o s e d ( )   { 
     v a r   a p p   =   A p p l i c a t i o n . c u r r e n t A p p l i c a t i o n ( ) ; 
     a p p . i n c l u d e S t a n d a r d A d d i t i o n s   =   t r u e ; 
     a p p . d i s p l a y A l e r t ( " P h o t o s   a p p   i s   n o t   r u n n i n g " ) ; 
 } 
 
 f u n c t i o n   g e t P h o t o s A p p ( )   { 
     v a r   a p p   =   A p p l i c a t i o n ( " P h o t o s " ) ; 
     a p p . i n c l u d e S t a n d a r d A d d i t i o n s   =   t r u e ; 
     a p p . a c t i v a t e ( ) ; 
     r e t u r n   a p p ; 
 } 
 
 / /   P r i n t i n g 
 / /   f u n c t i o n   l o g A l b u m s T o C o n s o l e ( a l b u m s )   { 
 / /       v a r   o u t p u t   =   [ ] ; 
 / /       f o r   ( v a r   i   =   0 ;   i   <   a l b u m s . l e n g t h ;   i + + )   { 
 / /           v a r   p a r t s   =   g e t F u l l A l b u m N a m e S t r u c t u r e ( a l b u m s [ i ] ) ; 
 / /           v a r   n a m e   =   p a r t s . j o i n ( " > " ) ; 
 / /           o u t p u t . p u s h ( n a m e ) ; 
 / /       } 
 / /       c o n s o l e . l o g ( " F o u n d " ,   a l b u m s . l e n g t h ,   " a l b u m s : " ) ; 
 / /       c o n s o l e . l o g ( o u t p u t . j o i n ( " \ n " ) ) ; 
 / /   } 
 
 / /   f u n c t i o n   l o g ( t e x t )   { 
 / /       c o n s o l e . l o g ( t e x t ) ; 
 / /   } 
                              !"jscr  ��ޭ