c r e a t e 	 P r o c e d u r e   [ d b o ] . [ p C u s t P r i c e G e t H i s t ]  
 	 @ C u s t N o   v a r c h a r ( 2 0 )  
 a s  
 / *  
 	 = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 	 A u t h o r : 	 T o m   S l a t e r  
 	 C r e a t e   d a t e :   3 / 1 5 / 2 0 1 0  
 	 D e s c r i p t i o n :   G e t   C u s t o m e r   P r i c e   H i s t o r y   f o r   C a t e g o r y   P r i c e   S c h e d u l e   M a i n t e n a n c e  
 	 ( D e r i v e d   f r o m   p W O 1 7 5 5 _ G e t C u s t D a t a   W r i t t e n   B y   C h a r l e s   R o j a s   -   C r e a t e   D a t e :   0 2 / 1 9 / 1 0 )  
 	 ( T M D - O r i g i n a l l y   p r o g r a m m e d   t o   r e t u r n   3 M o   S a l e s   ( P r i c e )   H i s t o r y   b y   C u s t o m e r ;   G r o u p e d   b y   B u y G r o u p N o )  
  
 	 M o d i f i e d   0 3 / 3 1 / 1 0   ( T M D - W O 1 8 0 5 ) 	 - A d d e d   S E L E C T   f o r   2 n d   t a b l e   ( T A B L E [ 1 ] )   t o   r e t u r n   P r i c e   S c h e d u l e s  
 	 M o d i f i e d   0 6 / 2 9 / 1 0   ( T M D - W O 1 8 3 2 ) 	 - C r e a t e d   t a b l e   U N I O N   t o   r e t u r n   d a t a   G R O U P e d   B Y   b o t h   C a t N o   a n d   B u y G r o u p N o  
 	 M o d i f i e d   1 0 / 0 5 / 1 0   ( T M D - W O 2 0 0 2 ) 	 - R e m o v e d   d a t e   f u n c t i o n s   f r o m   t h e   W H E R E   s t a t e m e n t s  
 	 	 	 	 	 - A d d e d   i n i t i a l   s e t u p   t o   l o a d   @ B e g 3 M o D a t e ,   @ E n d 3 M o D a t e ,  
 	 	 	 	 	         @ B e g 1 2 M o D a t e   &   @ E n d 1 2 M o D a t e   F R O M   F i s c a l C a l e n d a r  
 	 	 	 	 	 - A d d e d   t a b l e   J O I N s   t o   r e t u r n   S a l e s H i s t o r y 1 2 M o   &   G M P c t P r i c e C o s t 1 2 M o  
 	 M o d i f i e d   1 1 / 0 5 / 1 0   ( T M D - W O 2 1 5 2 ) 	 - U s e   C M . C u s t N a m e   i n s t e a d   o f   S O H . S e l l T o C u s t N a m e   f o r   S O H i s t   G r o u p i n g  
 	 	 	 	 	 - R e m o v e d   i n n e r   S E L E C T s   t h a t   w e r e   r e t u r n i n g   t h e   3 M o   a n d   1 2 M o   S O H i s t  
 	 	 	 	 	         ( S O H i s t   d a t a   w i l l   b e   s t o r e d   i n   t e m p   t a b l e s   a s   d e s c r i b e d   b e l o w )  
 	 	 	 	 	 - A d d e d   i n i t i a l   s e t u p   t o   l o a d   t e m p   t a b l e s   w i t h   1 2 M o   S O H i s t   f o r   s e l e c t e d   C u s t o m e r  
 	 	 	 	 	         ( # S a l e s B y C a t   &   # S a l e s B y G r p ,   G r o u p e d   b y   C a t N o   &   G r o u p N o   r e s p e c t i v e l y )  
 	 	 	 	 	 - R e m o v e d   r e f e r e n c e s   t o   C o m p e t i t o r P r i c e   t a b l e  
 	 	 	 	 	         ( O r i g i n a l l y   u s e d   f o r   L o w   C o s t   L e a d e r   I t e m s )  
 	 	 	 	 	 - A d d e d   U P D A T E   f o r   I t e m s   w h e r e   C u s t o m e r P r i c e . C u s t N o = ' L L L '  
 	 	 	 	 	         ( R e f l e c t s   L o w   C o s t   L e a d e r   I t e m s )  
 	 	 	 	 	 - A d d e d   c a l c u l a t i o n s   t o   r e t u r n   M a r g i n   @   A v e r a g e   C o s t   ( G M P c t A v g C o s t )  
 	 	 	 	 	 - A d d e d   t a b l e   J O I N s   t o   r e t u r n   S a l e s H i s t o r y T o t ,   G M P c t P r i c e C o s t T o t   &   G M P c t A v g C o s t T o t  
 	 	 	 	 	         ( R e f l e c t s   3 M o   S O H i s t   I N C L U D I N G   L o w   C o s t   L e a d e r   I t e m s )  
 	 	 	 	 	 - A d d e d   t a b l e   J O I N s   t o   r e t u r n   S a l e s H i s t o r y E C o m m ,   G M P c t P r i c e C o s t E C o m m   &   G M P c t A v g C o s t E C o m m  
 	 	 	 	 	         ( R e f l e c t s   3 M o   S O H i s t   f o r   E - C o m m e r c e   O r d e r s   O n l y )  
 	 = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
  
 	 e x e c   p C u s t P r i c e G e t H i s t   ' 0 6 5 2 5 1 '  
 * /  
  
  
 B E G I N  
 	 D E C L A R E 	 @ R e c s F o u n d   B I G I N T  
 	 S E T 	 @ R e c s F o u n d   =   0  
  
 	 - - S e e   i f   t h e r e   a r e   a n y   a p p r o v a l   r e c o r d s   w a i t i n g  
 	 S E L E C T 	 @ R e c s F o u n d   =   c o u n t ( * )  
 	 F R O M 	 U n p r o c e s s e d C a t e g o r y P r i c e   ( N o L o c k )  
 	 W H E R E 	 C u s t o m e r N o   =   @ C u s t N o  
  
 	 I F   I S N U L L ( @ R e c s F o u n d , 0 )   >   0  
 	       B E G I N  
 	 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 	 - -         * * *   B e g i n   T A B L E [ 0 ]   * * *         - -  
 	 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 	 - -         U n p r o c e s s e d   r e c o r d s   i n   U n p r o c e s s e d C a t e g o r y P r i c e         - -  
 	 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 	 S E L E C T 	 p U n p r o c e s s e d C a t e g o r y P r i c e I D ,  
 	 	 	 B r a n c h ,  
 	 	 	 C u s t o m e r N o ,  
 	 	 	 C u s t o m e r N a m e ,  
 	 	 	 G r o u p T y p e ,  
 	 	 	 G r o u p N o ,  
 	 	 	 G r o u p D e s c ,  
 	 	 	 B u y G r o u p N o ,  
 	 	 	 B u y G r o u p D e s c ,  
 	 	 	 S a l e s H i s t o r y ,  
 	 	 	 G M P c t P r i c e C o s t ,  
 	 	 	 G M P c t A v g C o s t ,  
 	 	 	 S a l e s H i s t o r y T o t ,  
 	 	 	 G M P c t P r i c e C o s t T o t ,  
 	 	 	 G M P c t A v g C o s t T o t ,  
 	 	 	 S a l e s H i s t o r y E C o m m ,  
 	 	 	 G M P c t P r i c e C o s t E C o m m ,  
 	 	 	 G M P c t A v g C o s t E C o m m ,  
 	 	 	 S a l e s H i s t o r y 1 2 M o ,  
 	 	 	 G M P c t P r i c e C o s t 1 2 M o ,  
 	 	 	 G M P c t A v g C o s t 1 2 M o ,  
 	 	 	 T a r g e t G M P c t ,  
 	 	 	 A p p r o v e d ,  
 	 	 	 E n t r y I D ,  
 	 	 	 E n t r y D t ,  
 	 	 	 C h a n g e I D ,  
 	 	 	 C h a n g e D t ,  
 	 	 	 S t a t u s C d ,  
 	 	 	 I S N U L L ( E x i s t i n g C u s t P r i c e P c t , - 1 )   a s   E x i s t i n g C u s t P r i c e P c t ,  
 	 	 	 ' 1 '   a s   R e c T y p e  
 	 	 F R O M 	 U n p r o c e s s e d C a t e g o r y P r i c e   ( N o L o c k )  
 	 	 W H E R E 	 C u s t o m e r N o   =   @ C u s t N o  
 	 	 O R D E R   B Y   C u s t o m e r N o ,   S a l e s H i s t o r y   d e s c  
 	 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 	 - -         * * *   E n d   T A B L E [ 0 ]   * * *         - -  
 	 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	       E N D  
 	 E L S E  
 	       B E G I N  
  
 - - d r o p   t a b l e   # 1 2 M o S a l e s B y C a t  
 - - d r o p   t a b l e   # 1 2 M o S a l e s B y G r p  
 - - d r o p   t a b l e   # S a l e s B y C a t  
 - - d r o p   t a b l e   # S a l e s B y G r p  
  
 	 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 	 - -         * * *   B e g i n   S a l e s   H i s t o r y   * * *         - -  
 	 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 	 - -         L o a d   l o c a l   d a t e   v a r i a b l e s   F R O M   F i s c a l C a l e n d a r         - -  
 	 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 	 D E C L A R E 	 @ B e g 3 M o D a t e   D A T E T I M E ,  
 	 	 	 @ E n d 3 M o D a t e   D A T E T I M E ,  
 	 	 	 @ B e g 1 2 M o D a t e   D A T E T I M E ,  
 	 	 	 @ E n d 1 2 M o D a t e   D A T E T I M E  
  
 	 	 - - B e g 3 M o D a t e  
 	 	 S E L E C T 	 D I S T I N C T   @ B e g 3 M o D a t e   =   C u r F i s c a l M t h B e g i n D t  
 	 	 F R O M   	 F i s c a l C a l e n d a r  
 	 	 W H E R E 	 ( D A T E P A R T ( y y y y , ( C A S T ( ( ( F i s c a l C a l Y e a r   *   1 0 0   +   F i s c a l C a l M o n t h )   *   1 0 0   +   0 1 )   a s   C H A R ( 8 ) ) ) )   *   1 0 0 )   +   D A T E P A R T ( m , ( C A S T ( ( ( F i s c a l C a l Y e a r   *   1 0 0   +   F i s c a l C a l M o n t h )   *   1 0 0   +   0 1 )   a s   C H A R ( 8 ) ) ) )  
 	 	 	 I N   ( S E L E C T   ( D A T E P A R T ( y y y y , D A T E A D D ( m , - 3 , ( C A S T ( ( ( F i s c a l C a l Y e a r   *   1 0 0   +   F i s c a l C a l M o n t h )   *   1 0 0   +   0 1 )   a s   C H A R ( 8 ) ) ) ) )   *   1 0 0 )   +   D A T E P A R T ( m , D A T E A D D ( m , - 3 , ( C A S T ( ( ( F i s c a l C a l Y e a r   *   1 0 0   +   F i s c a l C a l M o n t h )   *   1 0 0   +   0 1 )   a s   C H A R ( 8 ) ) ) ) )  
 	 	 	         F R O M       F i s c a l C a l e n d a r  
 	 	 	         W H E R E     C u r r e n t D t   =   C A S T   ( F L O O R   ( C A S T   ( G e t D a t e ( )   A S   F L O A T ) )   A S   D A T E T I M E ) )  
  
 	 	 - - E n d 3 M o D a t e  
 	 	 S E L E C T 	 D I S T I N C T   @ E n d 3 M o D a t e   =   C u r F i s c a l M t h E n d D t  
 	 	 F R O M 	 F i s c a l C a l e n d a r  
 	 	 W H E R E 	 ( D A T E P A R T ( y y y y , ( C A S T ( ( ( F i s c a l C a l Y e a r   *   1 0 0   +   F i s c a l C a l M o n t h )   *   1 0 0   +   0 1 )   a s   C H A R ( 8 ) ) ) )   *   1 0 0 )   +   D A T E P A R T ( m , ( C A S T ( ( ( F i s c a l C a l Y e a r   *   1 0 0   +   F i s c a l C a l M o n t h )   *   1 0 0   +   0 1 )   a s   C H A R ( 8 ) ) ) )  
 	 	 	 I N   ( S E L E C T   ( D A T E P A R T ( y y y y , D A T E A D D ( m , - 1 , ( C A S T ( ( ( F i s c a l C a l Y e a r   *   1 0 0   +   F i s c a l C a l M o n t h )   *   1 0 0   +   0 1 )   a s   C H A R ( 8 ) ) ) ) )   *   1 0 0 )   +   D A T E P A R T ( m , D A T E A D D ( m , - 1 , ( C A S T ( ( ( F i s c a l C a l Y e a r   *   1 0 0   +   F i s c a l C a l M o n t h )   *   1 0 0   +   0 1 )   a s   C H A R ( 8 ) ) ) ) )  
 	 	 	         F R O M       F i s c a l C a l e n d a r  
 	 	 	         W H E R E     C u r r e n t D t   =   C A S T   ( F L O O R   ( C A S T   ( G e t D a t e ( )   A S   F L O A T ) )   A S   D A T E T I M E ) )  
  
 	 	 - - B e g 1 2 M o D a t e  
 	 	 S E L E C T 	 D I S T I N C T   @ B e g 1 2 M o D a t e   =   C u r F i s c a l M t h B e g i n D t  
 	 	 F R O M 	 F i s c a l C a l e n d a r  
 	 	 W H E R E 	 ( D A T E P A R T ( y y y y , ( C A S T ( ( ( F i s c a l C a l Y e a r   *   1 0 0   +   F i s c a l C a l M o n t h )   *   1 0 0   +   0 1 )   a s   C H A R ( 8 ) ) ) )   *   1 0 0 )   +   D A T E P A R T ( m , ( C A S T ( ( ( F i s c a l C a l Y e a r   *   1 0 0   +   F i s c a l C a l M o n t h )   *   1 0 0   +   0 1 )   a s   C H A R ( 8 ) ) ) )  
 	 	 	 I N   ( S E L E C T   ( D A T E P A R T ( y y y y , D A T E A D D ( m , - 1 2 , ( C A S T ( ( ( F i s c a l C a l Y e a r   *   1 0 0   +   F i s c a l C a l M o n t h )   *   1 0 0   +   0 1 )   a s   C H A R ( 8 ) ) ) ) )   *   1 0 0 )   +   D A T E P A R T ( m , D A T E A D D ( m , - 1 2 , ( C A S T ( ( ( F i s c a l C a l Y e a r   *   1 0 0   +   F i s c a l C a l M o n t h )   *   1 0 0   +   0 1 )   a s   C H A R ( 8 ) ) ) ) )  
 	 	 	         F R O M       F i s c a l C a l e n d a r  
 	 	 	         W H E R E     C u r r e n t D t   =   C A S T   ( F L O O R   ( C A S T   ( G e t D a t e ( )   A S   F L O A T ) )   A S   D A T E T I M E ) )  
  
 	 	 - - E n d 1 2 M o D a t e  
 	 	 S E L E C T 	 D I S T I N C T   @ E n d 1 2 M o D a t e   =   C u r F i s c a l M t h E n d D t  
 	 	 F R O M 	 F i s c a l C a l e n d a r  
 	 	 W H E R E 	 ( D A T E P A R T ( y y y y , ( C A S T ( ( ( F i s c a l C a l Y e a r   *   1 0 0   +   F i s c a l C a l M o n t h )   *   1 0 0   +   0 1 )   a s   C H A R ( 8 ) ) ) )   *   1 0 0 )   +   D A T E P A R T ( m , ( C A S T ( ( ( F i s c a l C a l Y e a r   *   1 0 0   +   F i s c a l C a l M o n t h )   *   1 0 0   +   0 1 )   a s   C H A R ( 8 ) ) ) )  
 	 	 	 I N   ( S E L E C T   ( D A T E P A R T ( y y y y , D A T E A D D ( m , - 1 , ( C A S T ( ( ( F i s c a l C a l Y e a r   *   1 0 0   +   F i s c a l C a l M o n t h )   *   1 0 0   +   0 1 )   a s   C H A R ( 8 ) ) ) ) )   *   1 0 0 )   +   D A T E P A R T ( m , D A T E A D D ( m , - 1 , ( C A S T ( ( ( F i s c a l C a l Y e a r   *   1 0 0   +   F i s c a l C a l M o n t h )   *   1 0 0   +   0 1 )   a s   C H A R ( 8 ) ) ) ) )  
 	 	 	         F R O M       F i s c a l C a l e n d a r  
 	 	 	         W H E R E     C u r r e n t D t   =   C A S T   ( F L O O R   ( C A S T   ( G e t D a t e ( )   A S   F L O A T ) )   A S   D A T E T I M E ) )  
  
 - - s e l e c t   @ B e g 3 M o D a t e   a s   B e g 3 M o D a t e ,   @ E n d 3 M o D a t e   a s   E n d 3 M o D a t e ,   @ B e g 1 2 M o D a t e   a s   B e g 1 2 M o D a t e ,   @ E n d 1 2 M o D a t e   a s   E n d 1 2 M o D a t e  
  
 - - d e c l a r e   @ C u s t N o   v a r c h a r ( 2 0 )  
 - - s e t   @ C u s t N o = ' 0 6 5 2 5 1 '  
  
  
 	 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 	 - -         B u i l d   1 2 M o   B U L K   S a l e s   d a t a   f o r   s e l e c t e d   C u s t o m e r         - -  
 	 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
  
 	 	 - - G r o u p   b y   C a t e g o r y   ( # 1 2 M o S a l e s B y C a t )  
 	 	 S E L E C T 	 S O H . S e l l T o C u s t N o   a s   C u s t N o ,  
 	 	 	 C M . C u s t S h i p L o c a t i o n   a s   B r a n c h ,  
 - - 	 	 	 S O H . S e l l T o C u s t N a m e   a s   C u s t N a m e ,    
 	 	 	 C M . C u s t N a m e ,  
 	 	 	 S O D . I t e m N o ,  
 	 	 	 L E F T ( S O D . I t e m N o , 5 )   a s   C a t N o ,  
 - - 	 	 	 I M . C a t D e s c ,  
 	 	 	 I S N U L L ( C a t L i s t . C a t D e s c , ' N / A ' )   a s   C a t D e s c ,  
 	 	 	 I S N U L L ( C A S T ( C A S . G r o u p N o   a s   V A R C H A R ( 1 0 ) ) , ' N / A ' )   a s   B u y G r o u p N o ,  
 	 	 	 I S N U L L ( C A S . [ D e s c r i p t i o n ] , ' N / A ' )   a s   B u y G r o u p D e s c ,  
 	 	 	 I S N U L L ( S O D . Q t y S h i p p e d   *   S O D . N e t U n i t P r i c e , 0 )   a s   S a l e s ,  
 	 	 	 C A S E   W H E N   I S N U L L ( I B . P r i c e C o s t , 0 )   =   0  
 	 	 	           T H E N   S O D . Q t y S h i p p e d   *   S O D . N e t U n i t P r i c e   -   S O D . Q t y S h i p p e d   *   S O D . U n i t C o s t  
 	 	 	           E L S E   S O D . Q t y S h i p p e d   *   S O D . N e t U n i t P r i c e   -   S O D . Q t y S h i p p e d   *   I B . P r i c e C o s t    
 	 	 	 E N D   a s   P r i c e G M D o l ,  
 	 	 	 S O D . Q t y S h i p p e d   *   S O D . N e t U n i t P r i c e   -   S O D . Q t y S h i p p e d   *   S O D . U n i t C o s t   a s   A v g G M D o l ,  
 	 	 	 P r i c e . D i s c P c t   a s   E x i s t i n g C u s t P r i c e P c t ,  
 	 	 	 S O H . A R P o s t D t ,  
 	 	 	 S O H . O r d e r S o u r c e ,  
 	 	 	 I S N U L L ( S o u r c e L i s t . S o u r c e S e q , ' ' )   a s   O r d e r S o u r c e S e q ,  
 	 	 	 '           '   a s   L L I n d  
 	 	 I N T O 	 # 1 2 M o S a l e s B y C a t  
 	 	 F R O M 	 I t e m B r a n c h   I B   ( N o L o c k )   I N N E R   J O I N  
 	 	 	 S O H e a d e r H i s t   S O H   ( N o L o c k )   I N N E R   J O I N  
 	 	 	 S O D e t a i l H i s t   S O D   ( N o L o c k )  
 	 	 O N 	 S O H . p S O H e a d e r H i s t I D   =   S O D . f S O H e a d e r H i s t I D   I N N E R   J O I N  
 	 	 	 I t e m M a s t e r   I M   ( N o L o c k )  
 	 	 O N 	 S O D . I t e m N o   =   I M . I t e m N o  
 	 	 O N 	 I B . f I t e m M a s t e r I D   =   I M . p I t e m M a s t e r I D   A N D   I B . L o c a t i o n   =   S O D . I M L o c   L E F T   O U T E R   J O I N  
 	 	 	 C a t e g o r y B u y G r o u p s   C A S   ( N o L o c k )  
 	 	 O N 	 C A S . C a t e g o r y   =   L E F T ( S O D . I t e m N o , 5 )   I N N E R   J O I N  
 	 	 	 C u s t o m e r M a s t e r   C M   ( N o L o c k )  
 	 	 O N 	 C M . C u s t N o   =   S O H . S e l l T o C u s t N o   L E F T   O U T E R   J O I N  
 - - 	 	 	 C o m p e t i t o r P r i c e   C P   ( N o L o c k )  
 - - 	 	 O N 	 C P . P F C I t e m   =   S O D . I t e m N o   L E F T   O U T E R   J O I N  
 	 	 	 C u s t o m e r P r i c e   P r i c e   ( N o L o c k )  
 	 	 O N 	 ( P r i c e . I t e m N o   =   C A S T ( C A S . G r o u p N o   a s   V A R C H A R ( 2 0 ) )   o r   P r i c e . I t e m N o   =   C A S . C a t e g o r y )   A N D   P r i c e . C u s t N o   =   S O H . S e l l T o C u s t N o   L E F T   O U T E R   J O I N  
 	 	 	 ( S E L E C T 	 L D . L i s t V a l u e   A S   C a t N o ,   L D . L i s t D t l D e s c   A S   C a t D e s c  
 	 	 	   F R O M 	 L i s t M a s t e r   ( N o L o c k )   L M   I N N E R   J O I N  
 	 	 	 	 L i s t D e t a i l   ( N o L o c k )   L D  
 	 	 	   O N 	 L M . p L i s t M a s t e r I D   =   L D . f L i s t M a s t e r I D  
 	 	 	   W H E R E 	 L M . L i s t N a m e   =   ' C a t e g o r y D e s c ' )   C a t L i s t  
 	 	 O N     	 C a t L i s t . C a t N o   =   L E F T ( S O D . I t e m N o , 5 )   L E F T   O U T E R   J O I N  
 	 	 	 ( S E L E C T 	 L D . L i s t V a l u e   A S   S o u r c e ,   L D . L i s t D t l D e s c   A S   S o u r c e D e s c ,   L D . S e q u e n c e N o   A S   S o u r c e S e q  
 	 	 	   F R O M 	 L i s t M a s t e r   L M   ( N o L o c k )   I N N E R   J O I N  
 	 	 	 	 L i s t D e t a i l   L D   ( N o L o c k )  
 	 	 	   O N 	 L M . p L i s t M a s t e r I d   =   L D . f L i s t M a s t e r I d  
 	 	 	   W H E R E 	 L M . L i s t N a m e   =   ' S O E O r d e r S o u r c e ' )   S o u r c e L i s t  
 	 	 O N 	 S o u r c e L i s t . S o u r c e   =   S O H . O r d e r S o u r c e  
 	 	 	 - - U s e   l a s t   1 2   c l o s e d   m o n t h s   o f   S a l e s   I n v o i c e   d a t a ,   B u l k   O n l y  
 	 	 W H E R E 	 S U B S T R I N G ( S O D . I t e m N o , 1 2 , 1 )   i n   ( ' 0 ' , ' 1 ' , ' 5 ' )   A N D  
 	 	 	 ( C A S T ( F L O O R ( C A S T ( S O H . A R P o s t D t   A S   F L O A T ) )   A S   D A T E T I M E )   B E T W E E N   @ B e g 1 2 M o D a t e   a n d   @ E n d 1 2 M o D a t e )   A N D  
 - - 	 	 	 C A S E   W H E N   C P . P F C I t e m   i s   n u l l  
 - - 	 	 	           T H E N   ' '  
 - - 	 	 	           E L S E   ' S k i p '  
 - - 	 	 	 E N D   < >   ' S K I P '   A N D  
 	 	 	 S O H . S e l l T o C u s t N o   =   @ C u s t N o  
  
 	 	 - - U P D A T E   L o w   C o s t   L e a d e r   I t e m s  
 	 	 U P D A T E 	 # 1 2 M o S a l e s B y C a t  
 	 	 S E T 	 L L I n d   =   P r i c e . C u s t N o  
 	 	 F R O M 	 C u s t o m e r P r i c e   P r i c e  
 	 	 W H E R E 	 # 1 2 M o S a l e s B y C a t . I t e m N o   =   P r i c e . I t e m N o   A N D  
 	 	 	 P r i c e . C u s t N o   =   ' L L L '  
  
 - - s e l e c t   *   f r o m   # 1 2 M o S a l e s B y C a t  
 - - d r o p   t a b l e   # 1 2 M o S a l e s B y C a t  
  
  
 	 	 - - G r o u p   b y   B u y   G r o u p   ( # 1 2 M o S a l e s B y G r p )  
 	 	 S E L E C T 	 S O H . S e l l T o C u s t N o   a s   C u s t N o ,  
 	 	 	 C M . C u s t S h i p L o c a t i o n   a s   B r a n c h ,  
 - - 	 	 	 S O H . S e l l T o C u s t N a m e   a s   C u s t N a m e ,    
 	 	 	 C M . C u s t N a m e ,  
 	 	 	 S O D . I t e m N o ,  
 - - 	 	 	 C A S . G r o u p N o ,  
 	 	 	 I S N U L L ( C A S T ( C A S . G r o u p N o   a s   V A R C H A R ( 1 0 ) ) , ' N / A ' )   a s   G r o u p N o ,  
 	 	 	 I S N U L L ( C A S . [ D e s c r i p t i o n ] , ' N / A ' )   a s   G r o u p D e s c ,  
 	 	 	 I S N U L L ( C A S T ( C A S . G r o u p N o   a s   V A R C H A R ( 1 0 ) ) , ' N / A ' )   a s   B u y G r o u p N o ,  
 	 	 	 I S N U L L ( C A S . [ D e s c r i p t i o n ] , ' N / A ' )   a s   B u y G r o u p D e s c ,  
 	 	 	 I S N U L L ( S O D . Q t y S h i p p e d   *   S O D . N e t U n i t P r i c e , 0 )   a s   S a l e s ,  
 	 	 	 C A S E   W H E N   I S N U L L ( I B . P r i c e C o s t , 0 )   =   0  
 	 	 	           T H E N   S O D . Q t y S h i p p e d   *   S O D . N e t U n i t P r i c e   -   S O D . Q t y S h i p p e d   *   S O D . U n i t C o s t  
 	 	 	           E L S E   S O D . Q t y S h i p p e d   *   S O D . N e t U n i t P r i c e   -   S O D . Q t y S h i p p e d   *   I B . P r i c e C o s t    
 	 	 	 E N D   a s   P r i c e G M D o l ,  
 	 	 	 S O D . Q t y S h i p p e d   *   S O D . N e t U n i t P r i c e   -   S O D . Q t y S h i p p e d   *   S O D . U n i t C o s t   a s   A v g G M D o l ,  
 	 	 	 P r i c e . D i s c P c t   a s   E x i s t i n g C u s t P r i c e P c t ,  
 	 	 	 S O H . A R P o s t D t ,  
 	 	 	 S O H . O r d e r S o u r c e ,  
 	 	 	 I S N U L L ( S o u r c e L i s t . S o u r c e S e q , ' ' )   a s   O r d e r S o u r c e S e q ,  
 	 	 	 '           '   a s   L L I n d  
 	 	 I N T O 	 # 1 2 M o S a l e s B y G r p  
 	 	 F R O M 	 I t e m B r a n c h   I B   ( N o L o c k )   I N N E R   J O I N  
 	 	 	 S O H e a d e r H i s t   S O H   ( N o L o c k )   I N N E R   J O I N  
 	 	 	 S O D e t a i l H i s t   S O D   ( N o L o c k )  
 	 	 O N 	 S O H . p S O H e a d e r H i s t I D   =   S O D . f S O H e a d e r H i s t I D   I N N E R   J O I N  
 	 	 	 I t e m M a s t e r   I M   ( N o L o c k )  
 	 	 O N 	 S O D . I t e m N o   =   I M . I t e m N o  
 	 	 O N 	 I B . f I t e m M a s t e r I D   =   I M . p I t e m M a s t e r I D   A N D   I B . L o c a t i o n   =   S O D . I M L o c   L E F T   O U T E R   J O I N  
 	 	 	 C a t e g o r y B u y G r o u p s   C A S   ( N o L o c k )  
 	 	 O N 	 C A S . C a t e g o r y   =   L E F T ( S O D . I t e m N o , 5 )   I N N E R   J O I N  
 	 	 	 C u s t o m e r M a s t e r   C M   ( N o L o c k )  
 	 	 O N 	 C M . C u s t N o   =   S O H . S e l l T o C u s t N o   L E F T   O U T E R   J O I N  
 - - 	 	 	 C o m p e t i t o r P r i c e   C P   ( N o L o c k )  
 - - 	 	 O N 	 C P . P F C I t e m   =   S O D . I t e m N o   L E F T   O U T E R   J O I N  
 	 	 	 C u s t o m e r P r i c e   P r i c e   ( N o L o c k )  
 	 	 O N 	 ( P r i c e . I t e m N o   =   C A S T ( C A S . G r o u p N o   a s   V A R C H A R ( 2 0 ) )   o r   P r i c e . I t e m N o   =   C A S . C a t e g o r y )   A N D   P r i c e . C u s t N o   =   S O H . S e l l T o C u s t N o   L E F T   O U T E R   J O I N  
 	 	 	 ( S E L E C T 	 L D . L i s t V a l u e   A S   S o u r c e ,   L D . L i s t D t l D e s c   A S   S o u r c e D e s c ,   L D . S e q u e n c e N o   A S   S o u r c e S e q  
 	 	 	   F R O M 	 L i s t M a s t e r   L M   ( N o L o c k )   I N N E R   J O I N  
 	 	 	 	 L i s t D e t a i l   L D   ( N o L o c k )  
 	 	 	   O N 	 L M . p L i s t M a s t e r I d   =   L D . f L i s t M a s t e r I d  
 	 	 	   W H E R E 	 L M . L i s t N a m e   =   ' S O E O r d e r S o u r c e ' )   S o u r c e L i s t  
 	 	 O N 	 S o u r c e L i s t . S o u r c e   =   S O H . O r d e r S o u r c e  
 	 	 	 - - U s e   l a s t   1 2   c l o s e d   m o n t h s   o f   S a l e s   I n v o i c e   d a t a ,   B u l k   O n l y  
 	 	 W H E R E 	 S U B S T R I N G ( S O D . I t e m N o , 1 2 , 1 )   i n   ( ' 0 ' , ' 1 ' , ' 5 ' )   A N D  
 	 	 	 ( C A S T ( F L O O R ( C A S T ( S O H . A R P o s t D t   A S   F L O A T ) )   A S   D A T E T I M E )   B E T W E E N   @ B e g 1 2 M o D a t e   a n d   @ E n d 1 2 M o D a t e )   A N D  
 - - 	 	 	 C A S E   W H E N   C P . P F C I t e m   i s   n u l l  
 - - 	 	 	           T H E N   ' '  
 - - 	 	 	           E L S E   ' S k i p '  
 - - 	 	 	 E N D   < >   ' S K I P '   A N D  
 	 	 	 S O H . S e l l T o C u s t N o   =   @ C u s t N o  
  
 	 	 - - U P D A T E   L o w   C o s t   L e a d e r   I t e m s  
 	 	 U P D A T E 	 # 1 2 M o S a l e s B y G r p  
 	 	 S E T 	 L L I n d   =   P r i c e . C u s t N o  
 	 	 F R O M 	 C u s t o m e r P r i c e   P r i c e  
 	 	 W H E R E 	 # 1 2 M o S a l e s B y G r p . I t e m N o   =   P r i c e . I t e m N o   A N D  
 	 	 	 P r i c e . C u s t N o   =   ' L L L '  
  
 - - s e l e c t   *   f r o m   # 1 2 M o S a l e s B y G r p  
 - - d r o p   t a b l e   # 1 2 M o S a l e s B y G r p  
  
  
 	 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 	 - -         J O I N   S a l e s   d a t a   f o r   s p e c i f i c   d a t e   G R O U P i n g s         - -  
 	 	 - -           +   1 2 M o   S a l e s   E X C L U D I N G   L o w   C o s t   L e a d e r s               - -  
 	 	 - -           +     3 M o   S a l e s   E X C L U D I N G   L o w   C o s t   L e a d e r s               - -  
 	 	 - -           +     3 M o   S a l e s   I N C L U D I N G   L o w   C o s t   L e a d e r s               - -  
 	 	 - -           +     3 M o   S a l e s   E - C o m m e r c e   O n l y                                     - -  
 	 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
  
 	 	 - - G r o u p   b y   C a t e g o r y   ( # S a l e s B y C a t )  
 	 	 S E L E C T 	 t C a t S a l e s 1 2 M o S u m . C u s t N o ,  
 	 	 	 t C a t S a l e s 1 2 M o S u m . C u s t N a m e ,  
 	 	 	 t C a t S a l e s 1 2 M o S u m . B r a n c h ,  
 	 	 	 t C a t S a l e s 1 2 M o S u m . G r o u p N o ,  
 	 	 	 t C a t S a l e s 1 2 M o S u m . G r o u p D e s c ,  
 	 	 	 t C a t S a l e s 1 2 M o S u m . B u y G r o u p N o ,  
 	 	 	 t C a t S a l e s 1 2 M o S u m . B u y G r o u p D e s c ,  
 	 	 	 t C a t S a l e s 1 2 M o S u m . E x i s t i n g C u s t P r i c e P c t ,  
 	 	 	 I S N U L L ( t C a t S a l e s 1 2 M o S u m . G r o u p S a l e s 1 2 M o , 0 )   a s   G r o u p S a l e s 1 2 M o ,  
 	 	 	 I S N U L L ( t C a t S a l e s 1 2 M o S u m . P r i c e C o s t G M P c t 1 2 M o , 0 )   a s   P r i c e C o s t G M P c t 1 2 M o ,  
 	 	 	 I S N U L L ( t C a t S a l e s 1 2 M o S u m . A v g C o s t G M P c t 1 2 M o , 0 )   a s   A v g C o s t G M P c t 1 2 M o ,  
 	 	 	 I S N U L L ( t C a t S a l e s S u m . G r o u p S a l e s , 0 )   a s   G r o u p S a l e s ,  
 	 	 	 I S N U L L ( t C a t S a l e s S u m . P r i c e C o s t G M P c t , 0 )   a s   P r i c e C o s t G M P c t ,  
 	 	 	 I S N U L L ( t C a t S a l e s S u m . A v g C o s t G M P c t , 0 )   a s   A v g C o s t G M P c t ,  
 	 	 	 I S N U L L ( t C a t S a l e s T o t S u m . G r o u p S a l e s T o t , 0 )   a s   G r o u p S a l e s T o t ,  
 	 	 	 I S N U L L ( t C a t S a l e s T o t S u m . P r i c e C o s t G M P c t T o t , 0 )   a s   P r i c e C o s t G M P c t T o t ,  
 	 	 	 I S N U L L ( t C a t S a l e s T o t S u m . A v g C o s t G M P c t T o t , 0 )   a s   A v g C o s t G M P c t T o t ,  
 	 	 	 I S N U L L ( t C a t S a l e s E C o m m S u m . G r o u p S a l e s E C o m m , 0 )   a s   G r o u p S a l e s E C o m m ,  
 	 	 	 I S N U L L ( t C a t S a l e s E C o m m S u m . P r i c e C o s t G M P c t E C o m m , 0 )   a s   P r i c e C o s t G M P c t E C o m m ,  
 	 	 	 I S N U L L ( t C a t S a l e s E C o m m S u m . A v g C o s t G M P c t E C o m m , 0 )   a s   A v g C o s t G M P c t E C o m m  
 	 	 I N T O 	 # S a l e s B y C a t  
 	 	 F R O M 	 - - 1 2 M o   S a l e s   E X C L U D I N G   L o w   C o s t   L e a d e r s :   t C a t S a l e s 1 2 M o S u m  
 	 	 	 ( S E L E C T 	 t C a t S a l e s 1 2 M o . C u s t N o ,  
 	 	 	 	 t C a t S a l e s 1 2 M o . C u s t N a m e ,  
 	 	 	 	 t C a t S a l e s 1 2 M o . B r a n c h ,  
 	 	 	 	 t C a t S a l e s 1 2 M o . C a t N o   a s   G r o u p N o ,  
 	 	 	 	 t C a t S a l e s 1 2 M o . C a t D e s c   a s   G r o u p D e s c ,  
 	 	 	 	 t C a t S a l e s 1 2 M o . B u y G r o u p N o ,  
 	 	 	 	 t C a t S a l e s 1 2 M o . B u y G r o u p D e s c ,  
 	 	 	 	 S U M ( I S N U L L ( t C a t S a l e s 1 2 M o . S a l e s , 0 ) )   a s   G r o u p S a l e s 1 2 M o ,  
 	 	 	 	 C A S E   W H E N   S U M ( I S N U L L ( t C a t S a l e s 1 2 M o . S a l e s , 0 ) )   =   0  
 	 	 	 	           T H E N   0    
 	 	 	 	           E L S E   1 0 0   *   S U M ( I S N U L L ( t C a t S a l e s 1 2 M o . P r i c e G M D o l , 0 ) )   /   S U M ( I S N U L L ( t C a t S a l e s 1 2 M o . S a l e s , 0 ) )  
 	 	 	 	 E N D   a s   P r i c e C o s t G M P c t 1 2 M o ,  
 	 	 	 	 C A S E   W H E N   S U M ( I S N U L L ( t C a t S a l e s 1 2 M o . S a l e s , 0 ) )   =   0  
 	 	 	 	           T H E N   0    
 	 	 	 	           E L S E   1 0 0   *   S U M ( I S N U L L ( t C a t S a l e s 1 2 M o . A v g G M D o l , 0 ) )   /   S U M ( I S N U L L ( t C a t S a l e s 1 2 M o . S a l e s , 0 ) )  
 	 	 	 	 E N D   a s   A v g C o s t G M P c t 1 2 M o ,  
 	 	 	 	 M A X ( I S N U L L ( t C a t S a l e s 1 2 M o . E x i s t i n g C u s t P r i c e P c t , - 1 ) )   a s   E x i s t i n g C u s t P r i c e P c t  
 	 	 	   F R O M 	 ( S E L E C T 	 *  
 	 	 	 	   F R O M 	 # 1 2 M o S a l e s B y C a t   ( N o L o c k )  
 	 	 	 	   W H E R E 	 L L I n d   < >   ' L L L ' )   t C a t S a l e s 1 2 M o  
 	 	 	   G R O U P   B Y   t C a t S a l e s 1 2 M o . C u s t N o ,   t C a t S a l e s 1 2 M o . C u s t N a m e ,   t C a t S a l e s 1 2 M o . B r a n c h ,   t C a t S a l e s 1 2 M o . C a t N o ,   t C a t S a l e s 1 2 M o . C a t D e s c ,  
 	 	 	 	     t C a t S a l e s 1 2 M o . B u y G r o u p N o ,   t C a t S a l e s 1 2 M o . B u y G r o u p D e s c )   t C a t S a l e s 1 2 M o S u m   L E F T   O U T E R   J O I N  
  
 	 	 	 - - 3 M o   S a l e s   E X C L U D I N G   L o w   C o s t   L e a d e r s :   t C a t S a l e s S u m  
 	 	 	 ( S E L E C T 	 t C a t S a l e s . C a t N o   a s   G r o u p N o ,  
 	 	 	 	 S U M ( I S N U L L ( t C a t S a l e s . S a l e s , 0 ) )   a s   G r o u p S a l e s ,  
 	 	 	 	 C A S E   W H E N   S U M ( I S N U L L ( t C a t S a l e s . S a l e s , 0 ) )   =   0  
 	 	 	 	           T H E N   0    
 	 	 	 	           E L S E   1 0 0   *   S U M ( I S N U L L ( t C a t S a l e s . P r i c e G M D o l , 0 ) )   /   S U M ( I S N U L L ( t C a t S a l e s . S a l e s , 0 ) )  
 	 	 	 	 E N D   a s   P r i c e C o s t G M P c t ,  
 	 	 	 	 C A S E   W H E N   S U M ( I S N U L L ( t C a t S a l e s . S a l e s , 0 ) )   =   0  
 	 	 	 	           T H E N   0    
 	 	 	 	           E L S E   1 0 0   *   S U M ( I S N U L L ( t C a t S a l e s . A v g G M D o l , 0 ) )   /   S U M ( I S N U L L ( t C a t S a l e s . S a l e s , 0 ) )  
 	 	 	 	 E N D   a s   A v g C o s t G M P c t  
 	 	 	   F R O M 	 ( S E L E C T 	 *  
 	 	 	 	   F R O M 	 # 1 2 M o S a l e s B y C a t   ( N o L o c k )  
 	 	 	 	   W H E R E 	 L L I n d   < >   ' L L L '   A N D  
 	 	 	 	 	 ( C A S T ( F L O O R ( C A S T ( A R P o s t D t   A S   F L O A T ) )   A S   D A T E T I M E )   B E T W E E N   @ B e g 3 M o D a t e   a n d   @ E n d 3 M o D a t e ) )   t C a t S a l e s  
 	 	 	   G R O U P   B Y   t C a t S a l e s . C a t N o )   t C a t S a l e s S u m  
 	 	 	 O N 	 t C a t S a l e s 1 2 M o S u m . G r o u p N o   =   t C a t S a l e s S u m . G r o u p N o   L E F T   O U T E R   J O I N  
  
 	 	 	 - - 3 M o   S a l e s   I N C L U D I N G   L o w   C o s t   L e a d e r s :   t C a t S a l e s T o t S u m  
 	 	 	 ( S E L E C T 	 t C a t S a l e s T o t . C a t N o   a s   G r o u p N o ,  
 	 	 	 	 S U M ( I S N U L L ( t C a t S a l e s T o t . S a l e s , 0 ) )   a s   G r o u p S a l e s T o t ,  
 	 	 	 	 C A S E   W H E N   S U M ( I S N U L L ( t C a t S a l e s T o t . S a l e s , 0 ) )   =   0  
 	 	 	 	           T H E N   0    
 	 	 	 	           E L S E   1 0 0   *   S U M ( I S N U L L ( t C a t S a l e s T o t . P r i c e G M D o l , 0 ) )   /   S U M ( I S N U L L ( t C a t S a l e s T o t . S a l e s , 0 ) )  
 	 	 	 	 E N D   a s   P r i c e C o s t G M P c t T o t ,  
 	 	 	 	 C A S E   W H E N   S U M ( I S N U L L ( t C a t S a l e s T o t . S a l e s , 0 ) )   =   0  
 	 	 	 	           T H E N   0    
 	 	 	 	           E L S E   1 0 0   *   S U M ( I S N U L L ( t C a t S a l e s T o t . A v g G M D o l , 0 ) )   /   S U M ( I S N U L L ( t C a t S a l e s T o t . S a l e s , 0 ) )  
 	 	 	 	 E N D   a s   A v g C o s t G M P c t T o t  
 	 	 	   F R O M 	 ( S E L E C T 	 *  
 	 	 	 	   F R O M 	 # 1 2 M o S a l e s B y C a t   ( N o L o c k )  
 	 	 	 	   W H E R E 	 ( C A S T ( F L O O R ( C A S T ( A R P o s t D t   A S   F L O A T ) )   A S   D A T E T I M E )   B E T W E E N   @ B e g 3 M o D a t e   a n d   @ E n d 3 M o D a t e ) )   t C a t S a l e s T o t  
 	 	 	   G R O U P   B Y   t C a t S a l e s T o t . C a t N o )   t C a t S a l e s T o t S u m  
 	 	 	 O N 	 t C a t S a l e s 1 2 M o S u m . G r o u p N o   =   t C a t S a l e s T o t S u m . G r o u p N o   L E F T   O U T E R   J O I N  
  
 	 	 	 - - 3 M o   S a l e s   E - C o m m e r c e   O n l y :   t C a t S a l e s E C o m m S u m  
 	 	   	 ( S E L E C T 	 t C a t S a l e s E C o m m . C a t N o   a s   G r o u p N o ,  
 	 	 	 	 S U M ( I S N U L L ( t C a t S a l e s E C o m m . S a l e s , 0 ) )   a s   G r o u p S a l e s E C o m m ,  
 	 	 	 	 C A S E   W H E N   S U M ( I S N U L L ( t C a t S a l e s E C o m m . S a l e s , 0 ) )   =   0  
 	 	 	 	           T H E N   0    
 	 	 	 	           E L S E   1 0 0   *   S U M ( I S N U L L ( t C a t S a l e s E C o m m . P r i c e G M D o l , 0 ) )   /   S U M ( I S N U L L ( t C a t S a l e s E C o m m . S a l e s , 0 ) )  
 	 	 	 	 E N D   a s   P r i c e C o s t G M P c t E C o m m ,  
 	 	 	 	 C A S E   W H E N   S U M ( I S N U L L ( t C a t S a l e s E C o m m . S a l e s , 0 ) )   =   0  
 	 	 	 	           T H E N   0    
 	 	 	 	           E L S E   1 0 0   *   S U M ( I S N U L L ( t C a t S a l e s E C o m m . A v g G M D o l , 0 ) )   /   S U M ( I S N U L L ( t C a t S a l e s E C o m m . S a l e s , 0 ) )  
 	 	 	 	 E N D   a s   A v g C o s t G M P c t E C o m m  
 	 	 	   F R O M 	 ( S E L E C T 	 *  
 	 	 	 	   F R O M 	 # 1 2 M o S a l e s B y C a t   ( N o L o c k )  
 	 	 	 	   W H E R E 	 O r d e r S o u r c e S e q   =   ' 1 '   A N D   L L I n d   < >   ' L L L '   A N D  
 	 	 	 	 	 ( C A S T ( F L O O R ( C A S T ( A R P o s t D t   A S   F L O A T ) )   A S   D A T E T I M E )   B E T W E E N   @ B e g 3 M o D a t e   a n d   @ E n d 3 M o D a t e ) )   t C a t S a l e s E C o m m  
 	 	 	   G R O U P   B Y   t C a t S a l e s E C o m m . C a t N o )   t C a t S a l e s E C o m m S u m  
 	 	 	 O N 	 t C a t S a l e s 1 2 M o S u m . G r o u p N o   =   t C a t S a l e s E C o m m S u m . G r o u p N o  
  
 - - s e l e c t   *   f r o m   # S a l e s B y C a t  
 - - d r o p   t a b l e   # S a l e s B y C a t  
  
  
 	 	 - - G r o u p   b y   B u y   G r o u p   ( # S a l e s B y G r p )  
 	 	 S E L E C T 	 t G r p S a l e s 1 2 M o S u m . C u s t N o ,  
 	 	 	 t G r p S a l e s 1 2 M o S u m . C u s t N a m e ,  
 	 	 	 t G r p S a l e s 1 2 M o S u m . B r a n c h ,  
 	 	 	 t G r p S a l e s 1 2 M o S u m . G r o u p N o ,  
 	 	 	 t G r p S a l e s 1 2 M o S u m . G r o u p D e s c ,  
 	 	 	 t G r p S a l e s 1 2 M o S u m . B u y G r o u p N o ,  
 	 	 	 t G r p S a l e s 1 2 M o S u m . B u y G r o u p D e s c ,  
 	 	 	 t G r p S a l e s 1 2 M o S u m . E x i s t i n g C u s t P r i c e P c t ,  
 	 	 	 I S N U L L ( t G r p S a l e s 1 2 M o S u m . G r o u p S a l e s 1 2 M o , 0 )   a s   G r o u p S a l e s 1 2 M o ,  
 	 	 	 I S N U L L ( t G r p S a l e s 1 2 M o S u m . P r i c e C o s t G M P c t 1 2 M o , 0 )   a s   P r i c e C o s t G M P c t 1 2 M o ,  
 	 	 	 I S N U L L ( t G r p S a l e s 1 2 M o S u m . A v g C o s t G M P c t 1 2 M o , 0 )   a s   A v g C o s t G M P c t 1 2 M o ,  
 	 	 	 I S N U L L ( t G r p S a l e s S u m . G r o u p S a l e s , 0 )   a s   G r o u p S a l e s ,  
 	 	 	 I S N U L L ( t G r p S a l e s S u m . P r i c e C o s t G M P c t , 0 )   a s   P r i c e C o s t G M P c t ,  
 	 	 	 I S N U L L ( t G r p S a l e s S u m . A v g C o s t G M P c t , 0 )   a s   A v g C o s t G M P c t ,  
 	 	 	 I S N U L L ( t G r p S a l e s T o t S u m . G r o u p S a l e s T o t , 0 )   a s   G r o u p S a l e s T o t ,  
 	 	 	 I S N U L L ( t G r p S a l e s T o t S u m . P r i c e C o s t G M P c t T o t , 0 )   a s   P r i c e C o s t G M P c t T o t ,  
 	 	 	 I S N U L L ( t G r p S a l e s T o t S u m . A v g C o s t G M P c t T o t , 0 )   a s   A v g C o s t G M P c t T o t ,  
 	 	 	 I S N U L L ( t G r p S a l e s E C o m m S u m . G r o u p S a l e s E C o m m , 0 )   a s   G r o u p S a l e s E C o m m ,  
 	 	 	 I S N U L L ( t G r p S a l e s E C o m m S u m . P r i c e C o s t G M P c t E C o m m , 0 )   a s   P r i c e C o s t G M P c t E C o m m ,  
 	 	 	 I S N U L L ( t G r p S a l e s E C o m m S u m . A v g C o s t G M P c t E C o m m , 0 )   a s   A v g C o s t G M P c t E C o m m  
 	 	 I N T O 	 # S a l e s B y G r p  
 	 	 F R O M 	 - - 1 2 M o   S a l e s   E X C L U D I N G   L o w   C o s t   L e a d e r s :   t G r p S a l e s 1 2 M o S u m  
 	 	 	 ( S E L E C T 	 t G r p S a l e s 1 2 M o . C u s t N o ,  
 	 	 	 	 t G r p S a l e s 1 2 M o . C u s t N a m e ,  
 	 	 	 	 t G r p S a l e s 1 2 M o . B r a n c h ,  
 	 	 	 	 t G r p S a l e s 1 2 M o . G r o u p N o ,  
 	 	 	 	 t G r p S a l e s 1 2 M o . G r o u p D e s c ,  
 	 	 	 	 t G r p S a l e s 1 2 M o . B u y G r o u p N o ,  
 	 	 	 	 t G r p S a l e s 1 2 M o . B u y G r o u p D e s c ,  
 	 	 	 	 S U M ( I S N U L L ( t G r p S a l e s 1 2 M o . S a l e s , 0 ) )   a s   G r o u p S a l e s 1 2 M o ,  
 	 	 	 	 C A S E   W H E N   S U M ( I S N U L L ( t G r p S a l e s 1 2 M o . S a l e s , 0 ) )   =   0  
 	 	 	 	           T H E N   0    
 	 	 	 	           E L S E   1 0 0   *   S U M ( I S N U L L ( t G r p S a l e s 1 2 M o . P r i c e G M D o l , 0 ) )   /   S U M ( I S N U L L ( t G r p S a l e s 1 2 M o . S a l e s , 0 ) )  
 	 	 	 	 E N D   a s   P r i c e C o s t G M P c t 1 2 M o ,  
 	 	 	 	 C A S E   W H E N   S U M ( I S N U L L ( t G r p S a l e s 1 2 M o . S a l e s , 0 ) )   =   0  
 	 	 	 	           T H E N   0    
 	 	 	 	           E L S E   1 0 0   *   S U M ( I S N U L L ( t G r p S a l e s 1 2 M o . A v g G M D o l , 0 ) )   /   S U M ( I S N U L L ( t G r p S a l e s 1 2 M o . S a l e s , 0 ) )  
 	 	 	 	 E N D   a s   A v g C o s t G M P c t 1 2 M o ,  
 	 	 	 	 M A X ( I S N U L L ( t G r p S a l e s 1 2 M o . E x i s t i n g C u s t P r i c e P c t , - 1 ) )   a s   E x i s t i n g C u s t P r i c e P c t  
 	 	 	   F R O M 	 ( S E L E C T 	 *  
 	 	 	 	   F R O M 	 # 1 2 M o S a l e s B y G r p   ( N o L o c k )  
 	 	 	 	   W H E R E 	 L L I n d   < >   ' L L L ' )   t G r p S a l e s 1 2 M o  
 	 	 	   G R O U P   B Y   t G r p S a l e s 1 2 M o . C u s t N o ,   t G r p S a l e s 1 2 M o . C u s t N a m e ,   t G r p S a l e s 1 2 M o . B r a n c h ,   t G r p S a l e s 1 2 M o . G r o u p N o ,   t G r p S a l e s 1 2 M o . G r o u p D e s c ,  
 	 	 	 	     t G r p S a l e s 1 2 M o . B u y G r o u p N o ,   t G r p S a l e s 1 2 M o . B u y G r o u p D e s c )   t G r p S a l e s 1 2 M o S u m   L E F T   O U T E R   J O I N  
  
 	 	 	 - - 3 M o   S a l e s   E X C L U D I N G   L o w   C o s t   L e a d e r s :   t G r p S a l e s S u m  
 	 	 	 ( S E L E C T 	 t G r p S a l e s . G r o u p N o ,  
 	 	 	 	 S U M ( I S N U L L ( t G r p S a l e s . S a l e s , 0 ) )   a s   G r o u p S a l e s ,  
 	 	 	 	 C A S E   W H E N   S U M ( I S N U L L ( t G r p S a l e s . S a l e s , 0 ) )   =   0  
 	 	 	 	           T H E N   0    
 	 	 	 	           E L S E   1 0 0   *   S U M ( I S N U L L ( t G r p S a l e s . P r i c e G M D o l , 0 ) )   /   S U M ( I S N U L L ( t G r p S a l e s . S a l e s , 0 ) )  
 	 	 	 	 E N D   a s   P r i c e C o s t G M P c t ,  
 	 	 	 	 C A S E   W H E N   S U M ( I S N U L L ( t G r p S a l e s . S a l e s , 0 ) )   =   0  
 	 	 	 	           T H E N   0    
 	 	 	 	           E L S E   1 0 0   *   S U M ( I S N U L L ( t G r p S a l e s . A v g G M D o l , 0 ) )   /   S U M ( I S N U L L ( t G r p S a l e s . S a l e s , 0 ) )  
 	 	 	 	 E N D   a s   A v g C o s t G M P c t  
 	 	 	   F R O M 	 ( S E L E C T 	 *  
 	 	 	 	   F R O M 	 # 1 2 M o S a l e s B y G r p   ( N o L o c k )  
 	 	 	 	   W H E R E 	 L L I n d   < >   ' L L L '   A N D  
 	 	 	 	 	 ( C A S T ( F L O O R ( C A S T ( A R P o s t D t   A S   F L O A T ) )   A S   D A T E T I M E )   B E T W E E N   @ B e g 3 M o D a t e   a n d   @ E n d 3 M o D a t e ) )   t G r p S a l e s  
 	 	 	   G R O U P   B Y   t G r p S a l e s . G r o u p N o )   t G r p S a l e s S u m  
 	 	 	 O N 	 t G r p S a l e s 1 2 M o S u m . G r o u p N o   =   t G r p S a l e s S u m . G r o u p N o   L E F T   O U T E R   J O I N  
  
 	 	 	 - - 3 M o   S a l e s   I N C L U D I N G   L o w   C o s t   L e a d e r s :   t G r p S a l e s T o t S u m  
 	 	 	 ( S E L E C T 	 t G r p S a l e s T o t . G r o u p N o ,  
 	 	 	 	 S U M ( I S N U L L ( t G r p S a l e s T o t . S a l e s , 0 ) )   a s   G r o u p S a l e s T o t ,  
 	 	 	 	 C A S E   W H E N   S U M ( I S N U L L ( t G r p S a l e s T o t . S a l e s , 0 ) )   =   0  
 	 	 	 	           T H E N   0    
 	 	 	 	           E L S E   1 0 0   *   S U M ( I S N U L L ( t G r p S a l e s T o t . P r i c e G M D o l , 0 ) )   /   S U M ( I S N U L L ( t G r p S a l e s T o t . S a l e s , 0 ) )  
 	 	 	 	 E N D   a s   P r i c e C o s t G M P c t T o t ,  
 	 	 	 	 C A S E   W H E N   S U M ( I S N U L L ( t G r p S a l e s T o t . S a l e s , 0 ) )   =   0  
 	 	 	 	           T H E N   0    
 	 	 	 	           E L S E   1 0 0   *   S U M ( I S N U L L ( t G r p S a l e s T o t . A v g G M D o l , 0 ) )   /   S U M ( I S N U L L ( t G r p S a l e s T o t . S a l e s , 0 ) )  
 	 	 	 	 E N D   a s   A v g C o s t G M P c t T o t  
 	 	 	   F R O M 	 ( S E L E C T 	 *  
 	 	 	 	   F R O M 	 # 1 2 M o S a l e s B y G r p   ( N o L o c k )  
 	 	 	 	   W H E R E 	 ( C A S T ( F L O O R ( C A S T ( A R P o s t D t   A S   F L O A T ) )   A S   D A T E T I M E )   B E T W E E N   @ B e g 3 M o D a t e   a n d   @ E n d 3 M o D a t e ) )   t G r p S a l e s T o t  
 	 	 	   G R O U P   B Y   t G r p S a l e s T o t . G r o u p N o )   t G r p S a l e s T o t S u m  
 	 	 	 O N 	 t G r p S a l e s 1 2 M o S u m . G r o u p N o   =   t G r p S a l e s T o t S u m . G r o u p N o   L E F T   O U T E R   J O I N  
  
 	 	 	 - - 3 M o   S a l e s   E - C o m m e r c e   O n l y :   t G r p S a l e s E C o m m S u m  
 	 	   	 ( S E L E C T 	 t G r p S a l e s E C o m m . G r o u p N o ,  
 	 	 	 	 S U M ( I S N U L L ( t G r p S a l e s E C o m m . S a l e s , 0 ) )   a s   G r o u p S a l e s E C o m m ,  
 	 	 	 	 C A S E   W H E N   S U M ( I S N U L L ( t G r p S a l e s E C o m m . S a l e s , 0 ) )   =   0  
 	 	 	 	           T H E N   0    
 	 	 	 	           E L S E   1 0 0   *   S U M ( I S N U L L ( t G r p S a l e s E C o m m . P r i c e G M D o l , 0 ) )   /   S U M ( I S N U L L ( t G r p S a l e s E C o m m . S a l e s , 0 ) )  
 	 	 	 	 E N D   a s   P r i c e C o s t G M P c t E C o m m ,  
 	 	 	 	 C A S E   W H E N   S U M ( I S N U L L ( t G r p S a l e s E C o m m . S a l e s , 0 ) )   =   0  
 	 	 	 	           T H E N   0    
 	 	 	 	           E L S E   1 0 0   *   S U M ( I S N U L L ( t G r p S a l e s E C o m m . A v g G M D o l , 0 ) )   /   S U M ( I S N U L L ( t G r p S a l e s E C o m m . S a l e s , 0 ) )  
 	 	 	 	 E N D   a s   A v g C o s t G M P c t E C o m m  
 	 	 	   F R O M 	 ( S E L E C T 	 *  
 	 	 	 	   F R O M 	 # 1 2 M o S a l e s B y G r p   ( N o L o c k )  
 	 	 	 	   W H E R E 	 O r d e r S o u r c e S e q   =   ' 1 '   A N D   L L I n d   < >   ' L L L '   A N D  
 	 	 	 	 	 ( C A S T ( F L O O R ( C A S T ( A R P o s t D t   A S   F L O A T ) )   A S   D A T E T I M E )   B E T W E E N   @ B e g 3 M o D a t e   a n d   @ E n d 3 M o D a t e ) )   t G r p S a l e s E C o m m  
 	 	 	   G R O U P   B Y   t G r p S a l e s E C o m m . G r o u p N o )   t G r p S a l e s E C o m m S u m  
 	 	 	 O N 	 t G r p S a l e s 1 2 M o S u m . G r o u p N o   =   t G r p S a l e s E C o m m S u m . G r o u p N o  
  
 - - s e l e c t   *   f r o m   # S a l e s B y G r p  
 - - d r o p   t a b l e   # S a l e s B y G r p  
  
 	 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 	 - -         * * *   E n d   S a l e s   H i s t o r y   * * *         - -  
 	 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
  
  
 	 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 	 - -         * * *   B e g i n   T A B L E [ 0 ]   * * *         - -  
 	 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 	 - -         T a b l e   U N I O N   o f   S O H i s t   d a t a   G R O U P e d   B Y   b o t h   C a t N o   a n d   B u y G r o u p N o         - -  
 	 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 	 S E L E C T 	 D I S T I N C T  
 	 	 	 t U n i o n . B r a n c h ,  
 	 	 	 t U n i o n . C u s t o m e r N o ,  
 	 	 	 t U n i o n . C u s t o m e r N a m e ,  
 	 	 	 t U n i o n . G r o u p T y p e ,  
 	 	 	 t U n i o n . G r o u p N o ,  
 	 	 	 t U n i o n . G r o u p D e s c ,  
 	 	 	 B u y G r o u p N o ,  
 	 	 	 B u y G r o u p D e s c ,  
 	 	 	 I S N U L L ( t U n i o n . S a l e s H i s t o r y , 0 )   a s   S a l e s H i s t o r y ,  
 	 	 	 I S N U L L ( t U n i o n . G M P c t P r i c e C o s t , 0 )   a s   G M P c t P r i c e C o s t ,  
 	 	 	 I S N U L L ( t U n i o n . G M P c t A v g C o s t , 0 )   a s   G M P c t A v g C o s t ,  
 	 	 	 I S N U L L ( t U n i o n . S a l e s H i s t o r y T o t , 0 )   a s   S a l e s H i s t o r y T o t ,  
 	 	 	 I S N U L L ( t U n i o n . G M P c t P r i c e C o s t T o t , 0 )   a s   G M P c t P r i c e C o s t T o t ,  
 	 	 	 I S N U L L ( t U n i o n . G M P c t A v g C o s t T o t , 0 )   a s   G M P c t A v g C o s t T o t ,  
 	 	 	 I S N U L L ( t U n i o n . S a l e s H i s t o r y E C o m m , 0 )   a s   S a l e s H i s t o r y E C o m m ,  
 	 	 	 I S N U L L ( t U n i o n . G M P c t P r i c e C o s t E C o m m , 0 )   a s   G M P c t P r i c e C o s t E C o m m ,  
 	 	 	 I S N U L L ( t U n i o n . G M P c t A v g C o s t E C o m m , 0 )   a s   G M P c t A v g C o s t E C o m m ,  
 	 	 	 I S N U L L ( t U n i o n . S a l e s H i s t o r y 1 2 M o , 0 )   a s   S a l e s H i s t o r y 1 2 M o ,  
 	 	 	 I S N U L L ( t U n i o n . G M P c t P r i c e C o s t 1 2 M o , 0 )   a s   G M P c t P r i c e C o s t 1 2 M o ,  
 	 	 	 I S N U L L ( t U n i o n . G M P c t A v g C o s t 1 2 M o , 0 )   a s   G M P c t A v g C o s t 1 2 M o ,  
 	 	 	 I S N U L L ( t U n i o n . T a r g e t G M P c t , 0 )   a s   T a r g e t G M P c t ,  
 	 	 	 t U n i o n . A p p r o v e d ,  
 	 	 	 t U n i o n . R e c T y p e ,  
 	 	 	 t U n i o n . p U n p r o c e s s e d C a t e g o r y P r i c e I D ,  
 	 	 	 I S N U L L ( t U n i o n . E x i s t i n g C u s t P r i c e P c t , 0 )   a s   E x i s t i n g C u s t P r i c e P c t  
  
 	 	 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 	 	 - -         C a t e g o r i e s :   G R O U P   B Y   C a t N o         - -  
 	 	 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 	 F R O M 	 ( S E L E C T 	 S a l e s B y C a t . B r a n c h ,  
 	 	 	 	 S a l e s B y C a t . C u s t N o   a s   C u s t o m e r N o ,  
 	 	 	 	 S a l e s B y C a t . C u s t N a m e   a s   C u s t o m e r N a m e ,  
 	 	 	 	 S a l e s B y C a t . G r o u p N o ,  
 	 	 	 	 S a l e s B y C a t . G r o u p D e s c ,  
 	 	 	 	 S a l e s B y C a t . B u y G r o u p N o ,  
 	 	 	 	 S a l e s B y C a t . B u y G r o u p D e s c ,  
 	 	 	 	 S a l e s B y C a t . G r o u p S a l e s   a s   S a l e s H i s t o r y ,  
 	 	 	 	 R O U N D ( S a l e s B y C a t . P r i c e C o s t G M P c t , 2 )   a s   G M P c t P r i c e C o s t ,  
 	 	 	 	 R O U N D ( S a l e s B y C a t . A v g C o s t G M P c t , 2 )   a s   G M P c t A v g C o s t ,  
 	 	 	 	 S a l e s B y C a t . G r o u p S a l e s T o t   a s   S a l e s H i s t o r y T o t ,  
 	 	 	 	 R O U N D ( S a l e s B y C a t . P r i c e C o s t G M P c t T o t , 2 )   a s   G M P c t P r i c e C o s t T o t ,  
 	 	 	 	 R O U N D ( S a l e s B y C a t . A v g C o s t G M P c t T o t , 2 )   a s   G M P c t A v g C o s t T o t ,  
 	 	 	 	 S a l e s B y C a t . G r o u p S a l e s E C o m m   a s   S a l e s H i s t o r y E C o m m ,  
 	 	 	 	 R O U N D ( S a l e s B y C a t . P r i c e C o s t G M P c t E C o m m , 2 )   a s   G M P c t P r i c e C o s t E C o m m ,  
 	 	 	 	 R O U N D ( S a l e s B y C a t . A v g C o s t G M P c t E C o m m , 2 )   a s   G M P c t A v g C o s t E C o m m ,  
 	 	 	 	 S a l e s B y C a t . G r o u p S a l e s 1 2 M o   a s   S a l e s H i s t o r y 1 2 M o ,  
 	 	 	 	 R O U N D ( S a l e s B y C a t . P r i c e C o s t G M P c t 1 2 M o , 2 )   a s   G M P c t P r i c e C o s t 1 2 M o ,  
 	 	 	 	 R O U N D ( S a l e s B y C a t . A v g C o s t G M P c t 1 2 M o , 2 )   a s   G M P c t A v g C o s t 1 2 M o ,  
 	 	 	 	 0 . 0   a s   T a r g e t G M P c t ,  
 	 	 	 	 ' 0 '   a s   A p p r o v e d ,  
 	 	 	 	 ' 0 '   a s   R e c T y p e ,  
 	 	 	 	 ' C '   a s   G r o u p T y p e , 	 - - ' C '   =   C a t e g o r y  
 	 	 	 	 - 1   a s   p U n p r o c e s s e d C a t e g o r y P r i c e I D ,  
 	 	 	 	 S a l e s B y C a t . E x i s t i n g C u s t P r i c e P c t  
 	 	 	   F R O M 	 # S a l e s B y C a t   S a l e s B y C a t  
 	 	 U N I O N    
 	 	 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 	 	 - -         B u y   G r o u p s :   G R O U P   B Y   G r o u p N o         - -  
 	 	 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 	 	   S E L E C T 	 S a l e s B y G r p . B r a n c h ,  
 	 	 	 	 S a l e s B y G r p . C u s t N o   a s   C u s t o m e r N o ,  
 	 	 	 	 S a l e s B y G r p . C u s t N a m e   a s   C u s t o m e r N a m e ,  
 	 	 	 	 S a l e s B y G r p . G r o u p N o ,  
 	 	 	 	 S a l e s B y G r p . G r o u p D e s c ,  
 	 	 	 	 S a l e s B y G r p . B u y G r o u p N o ,  
 	 	 	 	 S a l e s B y G r p . B u y G r o u p D e s c ,  
 	 	 	 	 S a l e s B y G r p . G r o u p S a l e s   a s   S a l e s H i s t o r y ,  
 	 	 	 	 R O U N D ( S a l e s B y G r p . P r i c e C o s t G M P c t , 2 )   a s   G M P c t P r i c e C o s t ,  
 	 	 	 	 R O U N D ( S a l e s B y G r p . A v g C o s t G M P c t , 2 )   a s   G M P c t A v g C o s t ,  
 	 	 	 	 S a l e s B y G r p . G r o u p S a l e s T o t   a s   S a l e s H i s t o r y T o t ,  
 	 	 	 	 R O U N D ( S a l e s B y G r p . P r i c e C o s t G M P c t T o t , 2 )   a s   G M P c t P r i c e C o s t T o t ,  
 	 	 	 	 R O U N D ( S a l e s B y G r p . A v g C o s t G M P c t T o t , 2 )   a s   G M P c t A v g C o s t T o t ,  
 	 	 	 	 S a l e s B y G r p . G r o u p S a l e s E C o m m   a s   S a l e s H i s t o r y E C o m m ,  
 	 	 	 	 R O U N D ( S a l e s B y G r p . P r i c e C o s t G M P c t E C o m m , 2 )   a s   G M P c t P r i c e C o s t E C o m m ,  
 	 	 	 	 R O U N D ( S a l e s B y G r p . A v g C o s t G M P c t E C o m m , 2 )   a s   G M P c t A v g C o s t E C o m m ,  
 	 	 	 	 S a l e s B y G r p . G r o u p S a l e s 1 2 M o   a s   S a l e s H i s t o r y 1 2 M o ,  
 	 	 	 	 R O U N D ( S a l e s B y G r p . P r i c e C o s t G M P c t 1 2 M o , 2 )   a s   G M P c t P r i c e C o s t 1 2 M o ,  
 	 	 	 	 R O U N D ( S a l e s B y G r p . A v g C o s t G M P c t 1 2 M o , 2 )   a s   G M P c t A v g C o s t 1 2 M o ,  
 	 	 	 	 0 . 0   a s   T a r g e t G M P c t ,  
 	 	 	 	 ' 0 '   a s   A p p r o v e d ,  
 	 	 	 	 ' 0 '   a s   R e c T y p e ,  
 	 	 	 	 ' B '   a s   G r o u p T y p e , 	 - - ' B '   =   B u y   G r o u p  
 	 	 	 	 - 1   a s   p U n p r o c e s s e d C a t e g o r y P r i c e I D ,  
 	 	 	 	 S a l e s B y G r p . E x i s t i n g C u s t P r i c e P c t  
 	 	 	   F R O M 	 # S a l e s B y G r p   S a l e s B y G r p )   t U n i o n  
 	 	 O R D E R   B Y   I S N U L L ( t U n i o n . S a l e s H i s t o r y , 0 )   D E S C  
 	 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 	 - -         * * *   E n d   T A B L E [ 0 ]   * * *         - -  
 	 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
  
 - - s e l e c t 	 C u s t N o ,   C u s t N a m e ,   B r a n c h ,   C a t N o ,   C a t D e s c ,  
 - - 	 S U M ( I S N U L L ( S a l e s , 0 ) )   a s   S a l e s 1 2 M o  
 - - f r o m 	 # 1 2 M o S a l e s B y C a t  
 - - w h e r e 	 L L I n d   < >   ' L L L '  
 - - g r o u p   b y   C u s t N o ,   C u s t N a m e ,   B r a n c h ,   C a t N o ,   C a t D e s c  
 - - o r d e r   b y   C a t N o  
 - - s e l e c t   *   f r o m   # t e m p   w h e r e   G r o u p t y p e = ' C '   O r d e r   B y   G r o u p N o  
  
 - - s e l e c t 	 C u s t N o ,   C u s t N a m e ,   B r a n c h ,   G r o u p N o ,   G r o u p D e s c ,  
 - - 	 S U M ( I S N U L L ( S a l e s , 0 ) )   a s   S a l e s 1 2 M o  
 - - f r o m 	 # 1 2 M o S a l e s B y G r p  
 - - w h e r e 	 L L I n d   < >   ' L L L '  
 - - g r o u p   b y   C u s t N o ,   C u s t N a m e ,   B r a n c h ,   G r o u p N o ,   G r o u p D e s c  
 - - o r d e r   b y   G r o u p N o  
 - - s e l e c t   *   f r o m   # t e m p   w h e r e   G r o u p t y p e = ' B '   O r d e r   B y   G r o u p N o  
  
  
 	 	 D R O P   T A B L E   # 1 2 M o S a l e s B y C a t  
 	 	 D R O P   T A B L E   # 1 2 M o S a l e s B y G r p  
 	 	 D R O P   T A B L E   # S a l e s B y C a t  
 	 	 D R O P   T A B L E   # S a l e s B y G r p  
 	       E N D  
  
  
 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 - -         * * *   B e g i n   T A B L E [ 1 ]   * * *         - -  
 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 - -         2 n d   t a b l e   t o   r e t u r n   C u s t o m e r   P r i c e   S c h e d u l e s         - -  
 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 S E L E C T 	 C u s t N o   a s   C u s t o m e r N o ,  
 	 	 C u s t N a m e   a s   C u s t o m e r N a m e ,  
 	 	 S h i p L o c a t i o n   a s   B r a n c h ,  
 	 	 C r e d i t I n d ,  
 	 	 C o n t r a c t S c h d 1 ,  
 	 	 C o n t r a c t S c h d 2 ,  
 	 	 C o n t r a c t S c h d 3 ,  
 	 	 C o n t r a c t S c h e d u l e 4 ,  
 	 	 C o n t r a c t S c h e d u l e 5 ,  
 	 	 C o n t r a c t S c h e d u l e 6 ,  
 	 	 C o n t r a c t S c h e d u l e 7 ,  
 	 	 T a r g e t G r o s s M a r g i n P c t ,  
 	 	 W e b D i s c o u n t P c t ,  
 	 	 W e b D i s c o u n t I n d ,  
 	 	 ( S E L E C T   L D . L i s t D t l D e s c   F R O M   C u s t o m e r M a s t e r   ( N o L o c k )   I N N E R   J O I N  
 	 	         ( S E L E C T   L i s t V a l u e ,   L i s t D t l D e s c   F R O M   L i s t M a s t e r   ( N o L o c k )   I N N E R   J O I N   L i s t D e t a i l   ( N o L o c k )   O N   p L i s t M a s t e r I D   =   f L i s t M a s t e r I D   W H E R E   L i s t N a m e   =   ' C u s t D e f P r i c e S c h d ' )   L D  
 	 	   O N   L D . L i s t V a l u e   =   C u s t o m e r D e f a u l t P r i c e   W H E R E   C u s t N o   =   @ C u s t N o )   a s   C u s t o m e r D e f a u l t P r i c e ,  
 	 	 ( S E L E C T   L D . L i s t D t l D e s c   F R O M   C u s t o m e r M a s t e r   ( N o L o c k )   I N N E R   J O I N  
 	 	         ( S E L E C T   L i s t V a l u e ,   L i s t D t l D e s c   F R O M   L i s t M a s t e r   ( N o L o c k )   I N N E R   J O I N   L i s t D e t a i l   ( N o L o c k )   O N   p L i s t M a s t e r I D   =   f L i s t M a s t e r I D   W H E R E   L i s t N a m e   =   ' C u s t P r i c e I n d ' )   L D  
 	 	   O N   L D . L i s t V a l u e   =   C u s t o m e r P r i c e I n d   W H E R E   C u s t N o   =   @ C u s t N o )   a s   C u s t o m e r P r i c e I n d  
 	 F R O M     C u s t o m e r M a s t e r   C M   ( N o L o c k )    
 	 W H E R E   C M . C u s t N o   =   @ C u s t N o  
 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 - -         * * *   E n d   T A B L E [ 1 ]   * * *         - -  
 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 E N D  
  
 