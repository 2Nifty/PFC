U S E   [ P E R P ]  
 G O  
 / * * * * * *   O b j e c t :     S t o r e d P r o c e d u r e   [ d b o ] . [ p S O E G e t I t e m A l i a s ]         S c r i p t   D a t e :   0 1 / 3 1 / 2 0 1 2   1 1 : 4 9 : 3 7   * * * * * * /  
 S E T   A N S I _ N U L L S   O N  
 G O  
 S E T   Q U O T E D _ I D E N T I F I E R   O N  
 G O  
  
 C R E A T E   P R O C E D U R E   [ d b o ] . [ p S O E G e t I t e m A l i a s ]  
 	 @ S e a r c h I t e m N o   V A R C H A R ( 2 0 )   =   ' ' ,  
 	 @ O r g a n i z a t i o n   V A R C H A R ( 2 0 )   =   ' ' ,  
 	 @ P r i m a r y B r a n c h   V A R C H A R ( 1 0 )   =   ' ' ,  
 	 @ S e a r c h T y p e   V A R C H A R ( 1 0 )   =   ' '  
 A S  
 - -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 - -   A u t h o r : 	 	 T o m   S l a t e r  
 - -   C r e a t e   d a t e :   1 1 / 1 0 / 2 0 0 8  
 - -   D e s c r i p t i o n : 	 P E R P   S O E   I t e m   p r o c e d u r e :    
 - - 	 	 	 	 F i n d   t h e   i t e m   a n d   p o s s i b l y   t h e   c u s t o m e r   a l i a s  
 - - 	 	 	 	 S e a r c h T y p e   t e l l s   u s   t o   l o o k   f o r   a n   a l i a s   o r   a   P C   I t e m   ( V a l u e s :   A l i a s ,   P F C )  
 - -   M o d i f i e d :   1 2 / 2 2 / 2 0 1 1   S a t h i s h   I f   i t e m   A l i a s   n o t   f o u n d   f o r   g i v e n   S e l l   T o   n u m b e r ,   t h e   n e w   q u e r y   w i l l   t r y   t o   f i n d   i t e m   u s i n g   B i l l   T o   n u m b e r  
 - -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 - -  
 / *  
 e x e c   p S O E G e t I t e m A l i a s   ' 0 0 2 0 0 - 2 4 0 0 - 0 2 1 ' ,   ' 0 0 0 0 0 1 ' ,   ' 1 5 ' ,   ' P F C '  
  
 - -   T o   t e s t   b i l l   t o   C u s t N o  
 e x e c   p S O E G e t I t e m A l i a s   ' C B 5 1 6 1 8 2 1 2 Z ' ,   ' 0 0 1 0 0 6 ' ,   ' 1 5 ' ,   ' A l i a s '    
  
 * /  
 - -  
 B E G I N  
 	 S E T   N O C O U N T   O N ;  
 	 - -   s e t u p   e n v i r o n m e n t  
 	 d e c l a r e   @ A l i a s I D   i n t ;  
 	 d e c l a r e   @ I t e m I D   i n t ;  
 	 d e c l a r e   @ I t e m F o u n d I n   v a r c h a r ( 2 0 ) ;  
 	 d e c l a r e   @ P F C I t e m   v a r c h a r ( 2 0 ) ;  
 	 d e c l a r e   @ C u s t I t e m   v a r c h a r ( 2 0 ) ;  
 	 d e c l a r e   @ I t e m D e s c   v a r c h a r ( 5 0 ) ;  
 	 d e c l a r e   @ C u s t D e s c   v a r c h a r ( 5 0 ) ;  
 	 d e c l a r e   @ I t e m Q t y   d e c i m a l ( 1 8 , 0 ) ;  
 	 d e c l a r e   @ I t e m U O M   v a r c h a r ( 1 0 ) ;  
 	 d e c l a r e   @ A l t Q t y   d e c i m a l ( 1 8 , 0 ) ;  
 	 d e c l a r e   @ A l t U O M   v a r c h a r ( 1 0 ) ;  
 	 d e c l a r e   @ S u p e r Q t y   d e c i m a l ( 1 8 , 0 ) ;  
 	 d e c l a r e   @ S u p e r U O M   v a r c h a r ( 1 0 ) ;  
 	 d e c l a r e   @ P i e c e Q t y   d e c i m a l ( 1 8 , 0 ) ;  
 	 d e c l a r e   @ P i e c e U O M T e x t   v a r c h a r ( 1 0 ) ;  
 	 d e c l a r e   @ C o l o r I n d   c h a r ( 2 ) ;  
 	 d e c l a r e   @ S t o c k I n d   t i n y i n t ;  
 	 d e c l a r e   @ S K U I D   i n t ;  
 	 d e c l a r e   @ S K U C o u n t   i n t ;  
 	 d e c l a r e   @ A l t P r i c e     d e c i m a l ( 1 8 , 6 ) ;  
 	 d e c l a r e   @ A l t P r i c e U O M   v a r c h a r ( 1 0 ) ;  
 	 d e c l a r e   @ P r i c e C o d e   v a r c h a r ( 1 0 ) ;  
 	 d e c l a r e   @ Q t y P e r U n i t     v a r c h a r ( 2 0 ) ;  
 	 d e c l a r e   @ P r i c e O r i g i n     v a r c h a r ( 2 0 ) ;  
 	 d e c l a r e   @ R e p l a c e m e n t C o s t   d e c i m a l ( 1 8 , 6 ) ;  
 	 d e c l a r e   @ L i s t P r i c e   d e c i m a l ( 1 8 , 6 ) ;  
 	 d e c l a r e   @ S t d C o s t   d e c i m a l ( 1 8 , 6 ) ;  
 	 d e c l a r e   @ S V C o d e   v a r c h a r ( 1 0 ) ;  
 	 d e c l a r e   @ C V C o d e   v a r c h a r ( 1 0 ) ;  
 	 d e c l a r e   @ F V C o d e   v a r c h a r ( 1 0 ) ;  
 	 d e c l a r e   @ H u n d r e d W g h t   d e c i m a l ( 1 8 , 6 ) ;  
 	 d e c l a r e   @ W g h t   d e c i m a l ( 1 8 , 6 ) ;  
 	 d e c l a r e   @ G r o s s W g h t   d e c i m a l ( 1 8 , 6 ) ;  
 	 d e c l a r e   @ Q O H   b i g i n t ;  
 	 d e c l a r e   @ L o c N a m e   v a r c h a r ( 5 0 ) ;  
 	 d e c l a r e   @ C e r t R e q u i r e d I n d   c h a r ( 2 ) ;  
 	 d e c l a r e   @ S u b I t e m I n d   c h a r ( 2 ) ;  
 	 d e c l a r e   @ S e l l O u t I t e m I n d   c h a r ( 2 ) ;  
 	 d e c l a r e   @ E r r o r C l a s s   c h a r ( 4 ) ;  
 	 d e c l a r e   @ E r r o r T y p e   c h a r ( 4 ) ;  
 	 d e c l a r e   @ E r r o r C o d e   v a r c h a r ( 4 ) ;  
 	 - -   s e t   d e f a u l t s  
 	 s e t   @ E r r o r C l a s s   =   ' S O E ' ;  
 	 s e t   @ E r r o r T y p e   =   ' ' ;  
 	 s e t   @ E r r o r C o d e   =   ' 0 0 0 0 ' ;  
 	 s e t   @ I t e m F o u n d I n   =   ' ' ;  
 	 s e t   @ I t e m D e s c   =   ' ' ;  
 	 s e t   @ C u s t D e s c   =   ' ' ;  
 	 s e t   @ I t e m U O M   =   ' ' ;  
 	 s e t   @ I t e m I D   =   - 1 ;  
 	 s e t   @ A l i a s I D   =   - 1 ;  
  
 	 / *  
 	 P r i c e ,   P r i c e   M e t h o d ,   D i s c o u n t e d   P r i c e ,   I n v e n t o r y   p r i c e   1 ,   P r i c e   c o d e   f r o m   C a l l e r ,    
 	 C o m m i s s i o n   P e r c e n t a g e ,   C o m m i s s i o n   d o l l a r s ,   A l t .   P r i c e ,   A l t .   P r i c e   U O M ,    
 	 &   A l l   ( N a v i s i o n   S a l e s   D e s k )   W o r k s h e e t   F i e l d s    
 	 * /  
 	 - -   C h e c k   i n p u t  
 	 - -   T r y   A l i a s   f i r s t   i f   w e   g o t   a n   o r g a n i z a t i o n  
 	 I F   @ S e a r c h T y p e   =   ' A l i a s '  
 	 	 - -   l o o k   i n   i t e m   a l i a s  
 	 	 B E G I N  
 	 	 S E L E C T 	 @ A l i a s I D   =   p I t e m A l i a s I D      
 	 	 F R O M 	 I t e m A l i a s   W I T H   ( N O L O C K )  
 	 	 w h e r e 	 ( A l i a s I t e m N o   =   @ S e a r c h I t e m N o )  
 	 	 	 	 a n d 	 ( ( O r g a n i z a t i o n N o   =   @ O r g a n i z a t i o n )  
 	 	 	 	 o r   ( O r g a n i z a t i o n N o   =   ' 0 0 0 0 0 0 ' ) ) ;  
 	 	  
 	 	 - -   T r y   t o   g e t   i t e m   i n f o   u s i n g   B i l l   T o   n u m b e r  
 	 	 I F   i s n u l l ( @ A l i a s I D ,   - 1 )   =   - 1  
 	 	 	 B E G I N  
 	 	 	 	 S E L E C T 	 @ A l i a s I D   =   p I t e m A l i a s I D      
 	 	 	 	 F R O M 	 I t e m A l i a s   W I T H   ( N O L O C K )  
 	 	 	 	 w h e r e 	 ( A l i a s I t e m N o   =   @ S e a r c h I t e m N o )  
 	 	 	 	 	 	 a n d 	 O r g a n i z a t i o n N o   i n   (   S e l e c t 	 f b i l l t o N o    
 	 	 	 	 	 	 	 	 	 	 	 	 F r o m 	 C u s t o m e r M a s t e r   ( N O L O C K )    
 	 	 	 	 	 	 	 	 	 	 	 	 W h e r e 	 C u s t N o = @ O r g a n i z a t i o n )  
 	 	 	 E N D  
  
 	 	 I F   i s n u l l ( @ A l i a s I D ,   - 1 )   < >   - 1  
 	 	 	 - -   W e   g o t   a n   a l i a s ,   s o   d o   t h e   b i g   s e l e c t   a n d   b e   d o n e  
 	 	 	 B E G I N  
 	 	 	 S E L E C T   @ I t e m I D   =   p I t e m M a s t e r I D  
 	 	 	 	 , @ P F C I t e m   =   I t e m . I t e m N o  
 	 	 	 	 , @ C u s t I t e m   =   A l i a s . A l i a s I t e m N o  
 	 	 	 	 , @ I t e m D e s c   =   I t e m . I t e m D e s c  
 	 	 	 	 , @ C u s t D e s c   =   A l i a s . A l i a s D e s c  
 	 	 	 	 , @ I t e m Q t y   =   I t e m . S e l l S t k U M Q t y  
 	 	 	 	 , @ I t e m U O M   =   c a s e    
 	 	 	 	 	 w h e n   ( i s n u l l ( r t r i m ( C u s t U M . U M ) ,   ' ' )   < >   ' ' )   t h e n   A l i a s . U O M  
 	 	 	 	 	 e l s e   I t e m . S e l l S t k U M     e n d      
 	 	 	 	 , @ I t e m F o u n d I n   =   ' X R e f '  
 	 	 	 	 , @ S u p e r Q t y   =   i s n u l l ( S u p e r . Q t y P e r U M , 0 )  
 	 	 	 	 , @ S u p e r U O M   =   I t e m . S u p e r U M  
 	 	 	 	 , @ A l t Q t y   =   i s n u l l ( I t e m . S e l l S t k U M Q t y * A l t . Q t y P e r U M , 1 )  
 	 	 	 	 , @ A l t U O M   =   I t e m . S e l l U M  
 	 	 	 	 , @ P i e c e Q t y   =   i s n u l l ( P i e c e . A l t S e l l S t k U M Q t y , 0 )  
 	 	 	 	 , @ C o l o r I n d   =   I t e m . P r i c e W o r k S h e e t C o l o r I n d  
 	 	 	 	 , @ F V C o d e   =   I t e m . C o r p F i x e d V e l o c i t y  
 	 	 	 	 , @ L i s t P r i c e   =   I t e m . L i s t P r i c e  
 	 	 	 	 , @ H u n d r e d W g h t   =   i s n u l l ( I t e m . H u n d r e d W g h t , 0 )  
 	 	 	 	 , @ W g h t   =   i s n u l l ( I t e m . W g h t , 0 )  
 	 	 	 	 , @ G r o s s W g h t   =   c o a l e s c e ( I t e m . G r o s s W g h t , 0 )  
 	 	 	 	 , @ C e r t R e q u i r e d I n d   =   I t e m . C e r t R e q u i r e d I n d  
 	 	 	 	 , @ S u b I t e m I n d   =   i s n u l l ( I t e m . S u b I t e m I n d , ' N ' )  
 	 	 	 	 , @ S e l l O u t I t e m I n d   =   i s n u l l ( I t e m . S e l l O u t I t e m I n d , ' N ' )  
 	 	 	 	 F R O M   I t e m A l i a s   A l i a s   W I T H   ( N O L O C K )  
 	 	 	 	 i n n e r   j o i n   I t e m M a s t e r   I t e m   W I T H   ( N O L O C K )  
 	 	 	 	 	 o n   I t e m . I t e m N o   =   A l i a s . I t e m N o  
 	 	 	 	 i n n e r   j o i n   I t e m U M   W I T H   ( N O L O C K )  
 	 	 	 	 	 o n   I t e m . p I t e m M a s t e r I D   =   I t e m U M . f I t e m M a s t e r I D  
 	 	 	 	 	 a n d   I t e m . S e l l S t k U M   =   I t e m U M . U M  
 	 	 	 	 l e f t   o u t e r   j o i n   I t e m U M   S u p e r   W I T H   ( N O L O C K )  
 	 	 	 	 	 o n   I t e m . p I t e m M a s t e r I D   =   S u p e r . f I t e m M a s t e r I D  
 	 	 	 	 	 a n d   I t e m . S u p e r U M   =   S u p e r . U M  
 	 	 	 	 i n n e r   j o i n   I t e m U M   A l t   W I T H   ( N O L O C K )  
 	 	 	 	 	 o n   I t e m . p I t e m M a s t e r I D   =   A l t . f I t e m M a s t e r I D  
 	 	 	 	 	 a n d   I t e m . S e l l U M   =   A l t . U M  
 	 	 	 	 l e f t   o u t e r   j o i n   I t e m U M   C u s t U M   W I T H   ( N O L O C K )  
 	 	 	 	 	 o n   I t e m . p I t e m M a s t e r I D   =   C u s t U M . f I t e m M a s t e r I D  
 	 	 	 	 	 a n d   A l i a s . U O M   =   C u s t U M . U M  
 	 	 	 	 l e f t   o u t e r   j o i n   I t e m U M   P i e c e   W I T H   ( N O L O C K )  
 	 	 	 	 	 o n   I t e m . p I t e m M a s t e r I D   =   P i e c e . f I t e m M a s t e r I D  
 	 	 	 	 	 a n d   ' P C '   =   P i e c e . U M  
 	 	 	 	 w h e r e   p I t e m A l i a s I D = @ A l i a s I D ;  
 	 	 	 - -   n o w   g e t   o t h e r   d a t a  
 	 	 	 G O T O   G e t O t h e r ;  
 	 	 	 E N D  
 	 	 e l s e  
 	 	 	 b e g i n  
 	 	 	 s e t   @ E r r o r C o d e   =   ' 0 0 0 1 ' ;  
 	 	 	 s e t   @ E r r o r T y p e   =   ' E ' ;  
 	 	 	 G O T O   E r r o r R e s u l t ;  
 	 	 	 e n d  
 	 	 E N D  
  
 	 - -   T r y   t o   f i n d   t h e   i t e m   n u m b e r  
 	 I F   @ S e a r c h T y p e   =   ' P F C '  
 	 	 - -   l o o k   i n   i t e m   m a s t e r  
 	 	 B E G I N  
 	 	 - - p r i n t   ' S e a r c h i n g   I t e m ' ;  
 	 	 S E L E C T   @ I t e m I D   =   p I t e m M a s t e r I D      
 	 	 	 , @ C u s t I t e m   =   i s n u l l ( A l i a s . A l i a s I t e m N o , ' N o   A l i a s ' )  
 	 	 	 , @ P F C I t e m   =   I t e m . I t e m N o  
 	 	 	 , @ I t e m D e s c   =   I t e m . I t e m D e s c    
 	 	 	 , @ C u s t D e s c   =   i s n u l l ( A l i a s . A l i a s D e s c ,   ' ' )  
 	 	 	 , @ I t e m Q t y   =   I t e m . S e l l S t k U M Q t y  
 	 	 	 , @ I t e m U O M   =   I t e m . S e l l S t k U M      
 	 	 	 , @ I t e m F o u n d I n   =   ' I M '  
 	 	 	 , @ S u p e r Q t y   =   i s n u l l ( S u p e r . Q t y P e r U M , 0 )  
 	 	 	 , @ S u p e r U O M   =   I t e m . S u p e r U M  
 	 	 	 , @ A l t Q t y   =   i s n u l l ( I t e m . S e l l S t k U M Q t y * A l t . Q t y P e r U M , 1 )  
 	 	 	 , @ A l t U O M   =   I t e m . S e l l U M  
 	 	 	 , @ P i e c e Q t y   =   i s n u l l ( P i e c e . A l t S e l l S t k U M Q t y , 0 )  
 	 	 	 , @ C o l o r I n d   =   I t e m . P r i c e W o r k S h e e t C o l o r I n d  
 	 	 	 , @ F V C o d e   =   I t e m . C o r p F i x e d V e l o c i t y  
 	 	 	 , @ L i s t P r i c e   =   I t e m . L i s t P r i c e  
 	 	 	 , @ H u n d r e d W g h t   =   i s n u l l ( I t e m . H u n d r e d W g h t , 0 )  
 	 	 	 , @ W g h t   =   i s n u l l ( I t e m . W g h t , 0 )  
 	 	 	 , @ G r o s s W g h t   =   c o a l e s c e ( I t e m . G r o s s W g h t , 0 )  
 	 	 	 , @ C e r t R e q u i r e d I n d   =   c o a l e s c e ( I t e m . C e r t R e q u i r e d I n d ,   ' 0 ' )  
 	 	 	 , @ S u b I t e m I n d   =   i s n u l l ( I t e m . S u b I t e m I n d , ' N ' )  
 	 	 	 , @ S e l l O u t I t e m I n d   =   i s n u l l ( I t e m . S e l l O u t I t e m I n d , ' N ' )  
 	 	 	 F R O M   I t e m M a s t e r   I t e m   W I T H   ( N O L O C K )  
 	 	 	 i n n e r   j o i n   I t e m U M   W I T H   ( N O L O C K )  
 	 	 	 	 o n   I t e m . p I t e m M a s t e r I D   =   I t e m U M . f I t e m M a s t e r I D  
 	 	 	 	 a n d   I t e m . S e l l S t k U M   =   I t e m U M . U M  
 	 	 	 l e f t   o u t e r   j o i n   I t e m U M   S u p e r   W I T H   ( N O L O C K )  
 	 	 	 	 o n   I t e m . p I t e m M a s t e r I D   =   S u p e r . f I t e m M a s t e r I D  
 	 	 	 	 a n d   I t e m . S u p e r U M   =   S u p e r . U M  
 	 	 	 i n n e r   j o i n   I t e m U M   A l t   W I T H   ( N O L O C K )  
 	 	 	 	 o n   I t e m . p I t e m M a s t e r I D   =   A l t . f I t e m M a s t e r I D  
 	 	 	 	 a n d   I t e m . S e l l U M   =   A l t . U M  
 	 	 	 l e f t   o u t e r   j o i n   I t e m U M   P i e c e   W I T H   ( N O L O C K )  
 	 	 	 	 o n   I t e m . p I t e m M a s t e r I D   =   P i e c e . f I t e m M a s t e r I D  
 	 	 	 	 a n d   ' P C '   =   P i e c e . U M  
 	 	 	 l e f t   o u t e r   j o i n   I t e m A l i a s   A l i a s   W I T H   ( N O L O C K )  
 	 	 	 	 o n   I t e m . I t e m N o   =   A l i a s . I t e m N o  
 	 	 	 	 a n d   ( O r g a n i z a t i o n N o   =   @ O r g a n i z a t i o n )  
 	 	 	 w h e r e   I t e m . I t e m N o   =   @ S e a r c h I t e m N o ;  
 	 	 E N D  
 	 I F   i s n u l l ( @ I t e m I D , - 1 )   =   - 1  
 	 	 - -   I t e m   n o t   f o u n d ,   w e   a r e   d o n e  
 	 	 B E G I N  
 	 	 s e t   @ E r r o r C o d e   =   ' 0 0 0 1 ' ;  
 	 	 s e t   @ E r r o r T y p e   =   ' E ' ;  
 	 	 G O T O   E r r o r R e s u l t ;  
 	 	 E N D  
 G e t O t h e r :  
 	 s e t   @ Q O H   =   0 ;  
 	 s e t   @ S K U C o u n t   =   0 ;  
 	 s e l e c t   @ S K U I D   =   f I t e m M a s t e r I D  
 	 	 , @ R e p l a c e m e n t C o s t   =   R e p l a c e m e n t C o s t  
 	 	 , @ S t d C o s t   =   S t d C o s t  
 	 	 , @ S V C o d e   =   S a l e s V e l o c i t y C d  
 	 	 , @ C V C o d e   =   C a t V e l o c i t y C d  
 	 	 , @ S t o c k I n d   =   S t o c k I n d  
 	 	 F R O M   I t e m B r a n c h   W I T H   ( N O L O C K )  
 	 	 w h e r e   I t e m B r a n c h . f I t e m M a s t e r I D   =   @ I t e m I D  
 	 	 	 a n d   L o c a t i o n   =   @ P r i m a r y B r a n c h ;  
  
 	 I F   i s n u l l ( @ S K U I D , - 1 )   =   - 1  
 	 	 - -   S K U   n o t   f o u n d ,   g i v e   b a c k   a   w a r n i n g  
 	 	 B E G I N  
 	 	 s e t   @ E r r o r C o d e   =   ' 0 0 2 1 ' ;  
 	 	 s e t   @ E r r o r T y p e   =   ' W ' ;  
 	 	 s e l e c t   @ S K U C o u n t   =   c o u n t ( * )  
 	 	 	 F R O M   I t e m B r a n c h   W I T H   ( N O L O C K )  
 	 	 	 w h e r e   I t e m B r a n c h . f I t e m M a s t e r I D   =   @ I t e m I D ;  
 	 	 	 - - a n d   I t e m B r a n c h . S t o c k I n d   =   1 ;  
 	 	 I F   @ S K U C o u n t   =   0  
 	 	 	 - -   n o   S K U   f o u n d   a n y w h e r e  
 	 	 	 B E G I N  
 	 	 	 s e t   @ E r r o r C o d e   =   ' 0 0 2 2 ' ;  
 	 	 	 s e t   @ E r r o r T y p e   =   ' E ' ;  
 	 	 	 G O T O   E r r o r R e s u l t ;  
 	 	 	 E N D  
 	 	 E N D  
 	 e l s e  
 	 	 s e l e c t   @ Q O H   =   i s n u l l ( d b o . f G e t B r A v a i l a b i l i t y ( @ P F C I t e m ,   @ P r i m a r y B r a n c h ,   @ I t e m U O M ) , 0 ) ;  
  
 	 s e t 	 @ R e p l a c e m e n t C o s t   =   i s n u l l ( @ R e p l a c e m e n t C o s t , 0 ) ;  
 	 s e t   @ S t d C o s t   =   i s n u l l ( @ S t d C o s t , 0 ) ;  
 	 s e t 	 @ S V C o d e   =   i s n u l l ( @ S V C o d e , ' ' ) ;  
 	 s e t   @ C V C o d e   =   i s n u l l ( @ C V C o d e , ' ' ) ;  
 	 s e t   @ P i e c e U O M T e x t   =   c a s e    
 	 	 w h e n   c h a r i n d e x ( ' W T ' , @ A l t U O M ) < > 0   t h e n   ' L B S '  
 	 	 w h e n   c h a r i n d e x ( ' F T ' , @ A l t U O M ) < > 0   t h e n   ' F e e t '  
 	 	 e l s e   ' P c s '   e n d ;  
  
 	 s e l e c t   @ L o c N a m e   =   L o c N a m e  
 	 F R O M   L o c M a s t e r   W I T H   ( N O L O C K )  
 	 w h e r e   L o c I D   =   @ P r i m a r y B r a n c h ;  
 	 - -   N o r m a l   e n d   o f   p r o c e d u r e  
 	 G O T O   N o r m a l E n d ;  
  
 E r r o r R e s u l t :  
 	 - -   s o m e t h i n g   b a d   h a p p e n e d ,   w e   s e n d   b a c k   o n l y   t h e   p r o c e d u r e   r e s u l t s  
 	 s e l e c t   @ E r r o r C l a s s   a s   E r r o r C l a s s ,   @ E r r o r T y p e   a s   E r r o r T y p e ,   @ E r r o r C o d e   a s   E r r o r C o d e   ;  
 	 G O T O   P r o c E n d ;  
 N o r m a l E n d :  
 	 - -   N o r m a l   e n d   o f   p r o c e d u r e .   R e t u r n   p r o c e d u r e   r e s u l t s   a n d   d a t a  
 	 s e l e c t   @ E r r o r C l a s s   a s   E r r o r C l a s s ,   @ E r r o r T y p e   a s   E r r o r T y p e ,   @ E r r o r C o d e   a s   E r r o r C o d e   ;  
 	 - -   g i v e   i t   b a c k  
 	 s e l e c t   @ I t e m I D   a s   I t e m I D  
 	 	 , @ P F C I t e m   a s   F o u n d I t e m  
 	 	 , @ C u s t I t e m   a s   C u s t I t e m    
 	 	 , @ I t e m D e s c   a s   I t e m D e s c    
 	 	 , @ C u s t D e s c   a s   C u s t D e s c  
 	 	 , @ I t e m Q t y   a s   I t e m Q t y  
 	 	 , @ I t e m U O M   a s   I t e m U O M    
 	 	 , @ I t e m F o u n d I n   a s   I t e m F o u n d I n  
 	 	 , @ S u p e r Q t y   a s   S u p e r Q t y  
 	 	 , @ S u p e r U O M   a s   S u p e r U M  
 	 	 , @ A l t Q t y   a s   A l t Q t y P e r U M  
 	 	 , @ A l t U O M   a s   A l t P r i c e U M  
 	 	 , c a s e   w h e n   @ P i e c e Q t y   =   0   t h e n   @ I t e m Q t y   e l s e   @ P i e c e Q t y   e n d   a s   P i e c e Q t y  
 	 	 , @ P i e c e U O M T e x t   a s   P i e c e U O M T e x t  
 	 	 , i s n u l l ( @ C o l o r I n d , ' 0 ' )   a s   C o l o r I n d  
 	 	 , @ S V C o d e   a s   S a l e s V e l o c i t y C d  
 	 	 , @ C V C o d e   a s   C a t V e l o c i t y C d  
 	 	 , @ F V C o d e   a s   F i x e d V e l o c i t y C d  
 	 	 , i s n u l l ( @ S t o c k I n d , 0 )   a s   S t o c k I n d  
 	 	 , @ R e p l a c e m e n t C o s t   a s   R e p l a c e m e n t C o s t  
 	 	 , @ S t d C o s t   a s   S t d C o s t  
 	 	 , @ L i s t P r i c e   a s   L i s t P r i c e  
 	 	 , @ H u n d r e d W g h t   a s   H u n d r e d W g h t  
 	 	 , @ W g h t   a s   W g h t  
 	 	 , @ G r o s s W g h t   a s   G r o s s W g h t  
 	 	 , @ Q O H   a s   Q O H  
 	 	 , @ L o c N a m e   a s   L o c N a m e  
 	 	 , @ C e r t R e q u i r e d I n d   a s   C e r t R e q u i r e d I n d  
 	 	 , @ S u b I t e m I n d   a s   S u b I t e m I n d  
 	 	 , @ S e l l O u t I t e m I n d   a s   S e l l O u t I t e m I n d  
 	 	 ;  
 P r o c E n d :  
 - -   f i n a l   c l e a n   u p  
  
 E N D  
 