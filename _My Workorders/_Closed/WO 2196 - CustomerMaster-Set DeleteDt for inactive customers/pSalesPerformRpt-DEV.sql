 
 - -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 - -   P r o c e d u r e 	 : 	 [ p S a l e s P e r f o r m R p t ]  
 - -   R e s u l t 	 : 	  
 - -   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 - -   D a t e 	 	 D e v e l o p e r 	 A c t i o n                      
 - -   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 - -   0 8 / 1 2 / 2 0 1 0 	 S a t h i s h 	 	 C r e a t e  
 - -   1 2 / 0 3 / 2 0 1 0 	 c r o j a s 	 	 R e m o v e   C r e d i t   H o l d   f i l t e r   p e r   B o b   P .  
 - -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
    
 C R E A T E   P R O C E D U R E   [ d b o ] . [ p S a l e s P e r f o r m R p t ]  
 	 @ w h e r e S a l e s   n v a r c h a r ( 4 0 0 0 ) ,  
 	 @ w h e r e C u s t   n v a r c h a r ( 4 0 0 0 ) ,  
 	 @ a l l C u s t F l g   c h a r ( 1 ) ,  
 	 @ s t a r t D t   v a r c h a r ( 2 0 ) ,  
 	 @ e n d D t   v a r c h a r ( 2 0 )  
  
 A S  
 D E C L A R E 	 @ s t r S q l   n v a r c h a r ( 4 0 0 0 )  
 D E C L A R E 	 @ s t r S q l 2   n v a r c h a r ( 4 0 0 0 )  
 D E C L A R E 	 @ t o t W o r k D a y s   v a r c h a r ( 1 0 )  
  
 B E G I N  
 	 - -   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 - -   E X E C   [ p S a l e s P e r f o r m R p t ]   ' H d r . A R P o s t D t > =   ' ' 7 / 2 6 / 2 0 0 9 ' '   A N D   H d r . A R P o s t D t < =   ' ' 8 / 2 7 / 2 0 0 9 ' '   A N D   H d r . C u s t S h i p L o c = ' ' 1 5 ' ' ' ,   ' B r a n c h   =   ' ' 1 5 ' ' ' ,   ' Y ' ,   ' 7 / 2 6 / 2 0 0 9 ' ,   ' 8 / 2 7 / 2 0 0 9 '  
 	 - -   E X E C   [ p S a l e s P e r f o r m R p t ]   ' H d r . A R P o s t D t > =   ' ' 7 / 2 6 / 2 0 0 9 ' '   A N D   H d r . A R P o s t D t < =   ' ' 8 / 2 7 / 2 0 0 9 ' '   A N D   H d r . C u s t S h i p L o c = ' ' 1 5 ' ' ' ,   ' B r a n c h   =   ' ' 1 5 ' ' ' ,   ' N ' ,   ' 7 / 2 6 / 2 0 0 9 ' ,   ' 8 / 2 7 / 2 0 0 9 '  
 	 - -  
 	 - -   E X E C   [ p S a l e s P e r f o r m R p t ]   ' H d r . A R P o s t D t > =   ' ' 1 2 / 2 7 / 2 0 0 9 ' '   A N D   H d r . A R P o s t D t < =   ' ' 2 / 6 / 2 0 1 0 ' ' ' ,   ' 1 = 1 ' ,   ' N ' ,   ' 1 2 / 2 7 / 2 0 0 9 ' ,   ' 2 / 6 / 2 0 1 0 '  
 	 - -   E X E C   [ p S a l e s P e r f o r m R p t ]   ' H d r . A R P o s t D t > =   ' ' 1 2 / 2 7 / 2 0 0 9 ' '   A N D   H d r . A R P o s t D t < =   ' ' 2 / 6 / 2 0 1 0 ' ' ' ,   ' R e g i o n a l M g r   =   ' ' K e v i n   C h a v i s ' ' ' ,   ' N ' ,   ' 1 2 / 2 7 / 2 0 0 9 ' ,   ' 2 / 6 / 2 0 1 0 '  
 	 - -   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
  
 	 S E L E C T   @ t o t W o r k D a y s   =   c o u n t ( * )   F R O M   F i s c a l C a l e n d a r   W H E R E   C u r r e n t D t   > =   @ s t a r t D t   A N D   C u r r e n t D t   < =   @ e n d D t   A N D   W o r k D a y = 1  
  
  
 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 - - 	 	 	 	 	 	 	 	 	 	 	 	 	 - -  
 	 - - 	 N O T E : 	 T h e   l e n g t h   o f   t h e   q u e r y   r e q u i r e s   i t   t o   b e   s p l i t   a c r o s s   m u l t i p l e   N V A R C H A R   s t r i n g s . 	 - -  
 	 - - 	 	 T h e   t w o   s t r i n g s   a r e   t h e n   e x e c u t e d   t o g e t h e r   a s   f o l l o w s :   E X E C   ( @ s t r S q l   +   @ s t r S q l 2 ) . 	 - -  
 	 - - 	 	 	 	 	 	 	 	 	 	 	 	 	 - -  
 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 	 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
  
 S E T   @ s t r S q l   =  
 ' S E L E C T 	 i s n u l l ( t A l l C u s t S a l e s . B r a n c h ,   t A l l C u s t . C u s t S h i p L o c a t i o n )   A S   B r a n c h ,  
 	 i s n u l l ( t A l l C u s t S a l e s . C u s t N o ,   t A l l C u s t . C u s t N o )   A S   C u s t N o ,  
 	 i s n u l l ( t A l l C u s t . C u s t N a m e , ' ' ' ' )   A S   C u s t N a m e ,  
 	 i s n u l l ( t A l l C u s t . C h a i n C d , ' ' ' ' )   A S   C h a i n ,  
 	 i s n u l l ( t A l l C u s t . P r i c e C d , ' ' ' ' )   A S   P r i c e C d ,  
 	 i s n u l l ( t A l l C u s t S a l e s . N e t S a l e s , 0 )   A S   N e t S a l e s ,  
 	 i s n u l l ( t A l l C u s t S a l e s . G M D o l l a r , 0 )   A S   G M D o l l a r ,  
 	 i s n u l l ( t A l l C u s t S a l e s . G M P c t , 0 )   A S   G M P c t ,  
 	 i s n u l l ( t A l l C u s t . W e e k l y S a l e s G o a l , 0 )   /   5   *   '   +   @ t o t W o r k D a y s   +   '   A S   G o a l G M D o l ,  
 	 - - i s n u l l ( t A l l C u s t . G r o s s M a r g i n P c t   , 0 )   *   1 0 0   A S   G o a l G M P c t ,  
 	 i s n u l l ( t A l l C u s t . G r o s s M a r g i n P c t   , 0 )   A S   G o a l G M P c t ,  
 	 i s n u l l ( t A l l C u s t S a l e s . T o t W g t , 0 )   A S   T o t W g t , 	 	 	 	 	 	 	  
 	 i s n u l l ( t A l l C u s t S a l e s . E C o m m S a l e s , 0 )   A S   E C o m m S a l e s ,  
 	 i s n u l l ( t A l l C u s t S a l e s . E C o m m G M D o l l a r , 0 )   A S   E C o m m G M D o l l a r ,  
 	 i s n u l l ( t A l l C u s t S a l e s . e C o m m G M P c t , 0 )   A S   e C o m m G M P c t ,  
 	 i s n u l l ( t A l l C u s t S a l e s . S t a t e , ' ' ' ' )   A S   S t a t e ,  
 	 i s n u l l ( t A l l C u s t . S a l e s T e r r i t o r y , ' ' ' ' )   A S   S a l e s T e r r i t o r y ,  
 	 C A S T ( I S N U L L ( t A l l C u s t . I n s i d e R e p , ' ' ' ' )   A S   v a r c h a r ( 2 5 0 ) )   A S   I n s i d e R e p ,  
 	 C A S T ( I S N U L L ( t A l l C u s t . O u t s i d e R e p , ' ' ' ' )   A S   v a r c h a r ( 2 5 0 ) )   A S   O u t s i d e R e p ,  
 	 C A S T ( I S N U L L ( t R e g i o n L o c . R e g i o n a l M g r , ' ' O p e n ' ' )   A S   v a r c h a r ( 2 5 0 ) )   A S   R e g i o n a l M g r  
   F R O M 	 - - t A l l C u s t  
 	 ( S E L E C T 	 C M . C u s t S h i p L o c a t i o n ,  
 	 	 C M . C u s t N o ,  
 	 	 C M . C u s t N a m e ,  
 	 	 C M . C h a i n C d ,  
 	 	 C M . P r i c e C d ,  
 	 	 C M . W e e k l y S a l e s G o a l ,  
 	 	 C M . G r o s s M a r g i n P c t ,  
 	 	 C M . S a l e s T e r r i t o r y ,  
 	 	 - - I n s i d e R e p . R e p N o t e s   A S   I n s i d e R e p ,  
 	 	 I n s i d e R e p . R e p N a m e   A S   I n s i d e R e p ,  
 	 	 O u t s i d e R e p . R e p N a m e   A S   O u t s i d e R e p  
 	   F R O M 	 C u s t o m e r M a s t e r   C M   ( N o L o c k )   L E F T   O U T E R   J O I N  
 	 	 R e p M a s t e r   I n s i d e R e p   ( N o L o c k )  
 	   O N 	 I n s i d e R e p . R e p N o   =   C M . S u p p o r t R e p N o   L E F T   O U T E R   J O I N  
 	 	 R e p M a s t e r   O u t s i d e R e p   ( N o L o c k )  
 	   O N 	 O u t s i d e R e p . R e p N o   =   C M . S l s R e p N o  
 	 	 - -   W H E R E 	 i s n u l l ( C M . C r e d i t I n d , ' ' ' ' )   n o t   i n   ( ' ' X ' ' , ' ' E ' ' )  
 	 	 - -   R e m o v e d   p e r   B o b   P   o n   1 2 / 0 3 / 2 0 1 0  
 	 )   t A l l C u s t   L E F T   O U T E R   J O I N  
 	 - - t R e g i o n L o c  
 	 ( S E L E C T 	 R e g i o n a l M g r . S a l e s R e g i o n N o ,  
 	 	 R e g i o n a l M g r . R e p N a m e   A S   R e g i o n a l M g r ,  
 	 	 R e g i o n a l L o c . L o c I D  
 	   F R O M 	 R e p M a s t e r   R e g i o n a l M g r   ( N o L o c k )   I N N E R   J O I N  
 	 	 L o c M a s t e r   R e g i o n a l L o c   ( N o L o c k )  
 	   O N 	 R e g i o n a l M g r . S a l e s R e g i o n N o   =   R e g i o n a l L o c . S a l e s R e g i o n N o  
 	   W H E R E 	 R e p C l a s s = ' ' R ' ' )   t R e g i o n L o c  
 	 O N 	 t A l l C u s t . C u s t S h i p L o c a t i o n   =   t R e g i o n L o c . L o c I D   '  
  
 i f   ( @ a l l C u s t F l g   =   ' Y ' )  
           S E T   @ s t r S q l   =   @ s t r S q l   +   ' L E F T   O U T E R   J O I N '  
 e l s e  
           S E T   @ s t r S q l   =   @ s t r S q l   +   ' I N N E R   J O I N '  
  
 S E T   @ s t r S q l   =   @ s t r S q l   +   '  
 	 - - t A l l C u s t S a l e s  
 	 ( S E L E C T 	 t S a l e s . B r a n c h ,  
 	 	 t S a l e s . C u s t N o ,  
 	 	 s u m ( t S a l e s . N e t S a l e s )   A S   N e t S a l e s ,  
 	 	 s u m ( t S a l e s . G M D o l l a r )   A S   G M D o l l a r ,  
 	 	 C A S E   W H E N   S U M ( t S a l e s . N e t S a l e s )   =   0   T H E N   0   E L S E   ( ( s u m ( t S a l e s . G M D o l l a r ) )   /   s u m ( ( t S a l e s . N e t S a l e s ) ) )   *   1 0 0   E N D   A S   G M P c t ,  
 	 	 s u m ( t S a l e s . T o t W g t )   T o t W g t ,  
 	 	 s u m ( t S a l e s . E C o m m S a l e s )   A S   E C o m m S a l e s ,  
 	 	 s u m ( t S a l e s . E C o m m G M D o l l a r )   A S   E C o m m G M D o l l a r ,  
 	 	 C A S E   W H E N   s u m ( t S a l e s . E C o m m S a l e s )   =   0   T H E N   0   E L S E   ( s u m ( t S a l e s . E C o m m G M D o l l a r )   /   s u m ( t S a l e s . E C o m m S a l e s )   *   1 0 0 )   E N D   A S   E C o m m G M P c t ,  
 	 	 t S a l e s . S t a t e  
 	   F R O M 	 - - t S a l e s  
 	 	 ( S E L E C T 	 H d r . C u s t S h i p L o c   A S   B r a n c h ,  
 	 	 	 H d r . S e l l T o C u s t N o   A S   C u s t N o ,  
 	 	 	 S U M ( H d r . N e t S a l e s )   A S   N e t S a l e s ,    
 	 	 	 S U M ( H d r . N e t S a l e s   -   H d r . T o t a l C o s t )   A S   G M D o l l a r ,    
 	 	 	 C A S E   W H E N   S U M ( H d r . N e t S a l e s )   =   0   T H E N   0   E L S E   ( ( S U M ( H d r . N e t S a l e s   -   H d r . T o t a l C o s t ) )   /   S U M ( H d r . N e t S a l e s ) )   *   1 0 0   E N D   A S   G M P c t ,  
 	 	 	 S U M ( H d r . S h i p W g h t )   A S   T o t W g t ,    
 	 	 	 C A S E   W H E N   L i s t . S e q u e n c e N o   =   1   T H E N   S U M ( i s n u l l ( H d r . N e t S a l e s , 0 ) )   E L S E   0   E N D   A S   E C o m m S a l e s ,  
 	 	 	 C A S E   W H E N   L i s t . S e q u e n c e N o   =   1   T H E N   i s n u l l ( S U M ( H d r . N e t S a l e s   -   H d r . T o t a l C o s t ) , 0 )   E L S E   0   E N D   A S   E C o m m G M D o l l a r ,  
 	 	 	 m a x ( H d r . B i l l T o S t a t e )   A S   S t a t e  
 	 	   F R O M 	 S O H e a d e r H i s t   H d r   ( N o L o c k )   L E F T   O U T E R   J O I N  
 	 	 - - C u s t  
 	 	 ( S E L E C T 	 C u s t N o  
 	 	   F R O M 	 C u s t o m e r M a s t e r   ( N o L o c k ) )   C u s t  
 	 	 O N 	 H d r . S e l l T o C u s t N o   =   C u s t . C u s t N o   L E F T   O U T E R   J O I N  
 	 	 - - L i s t  
 	 	 ( S E L E C T 	 L M . L i s t N a m e ,  
 	 	 	 L D . L i s t V a l u e ,  
 	 	 	 L D . L i s t D t l D e s c ,  
 	 	 	 L D . S e q u e n c e N o  
 	 	   F R O M 	 L i s t M a s t e r   L M   ( N o L o c k )   I N N E R   J O I N  
 	 	 	 L i s t D e t a i l   L D   ( N o L o c k )  
 	 	   O N 	 L M . p L i s t M a s t e r I D = L D . f L i s t M a s t e r I D  
 	 	   W H E R E 	 L M . L i s t N a m e   =   ' ' S O E O r d e r S o u r c e ' ' )   L i s t '  
  
 S E T   @ s t r S q l 2   =  
 ' 	 	 O N 	 L i s t . L i s t V a l u e   =   H d r . O r d e r S o u r c e  
 	 	 W H E R E 	 '   +     @ w h e r e S a l e s   +   '  
 	 	 G R O U P   B Y   H d r . S e l l T o C u s t N o ,   H d r . C u s t S h i p L o c ,   L i s t . S e q u e n c e N o )   t S a l e s  
 	   G R O U P   B Y   t S a l e s . C u s t N o ,   t S a l e s . B r a n c h ,   t S a l e s . S t a t e )   t A l l C u s t S a l e s  
   O N 	 t A l l C u s t . C u s t N o   =   t A l l C u s t S a l e s . C u s t N o  
   W H E R E 	 '   +     @ w h e r e C u s t   +   '  
   O R D E R   B Y   C u s t N o ,   B r a n c h '  
  
 p r i n t   @ s t r S q l  
 p r i n t   @ s t r S q l 2  
  
 - - E X E C   s p _ e x e c u t e s q l   @ s t r S q l    
 E X E C   ( @ s t r S q l   +   @ s t r S q l 2 )  
  
 E N D  
 