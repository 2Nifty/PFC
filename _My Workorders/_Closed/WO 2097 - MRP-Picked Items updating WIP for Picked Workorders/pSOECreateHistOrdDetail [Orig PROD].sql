 
 C R E A T E   P R O C E D U R E   [ d b o ] . [ p S O E C r e a t e H i s t O r d D e t a i l ]    
 	 - -   A d d   t h e   p a r a m e t e r s   f o r   t h e   s t o r e d   p r o c e d u r e   h e r e  
         @ u s e r N a m e   V A R C H A R ( 5 0 )   =   N U L L ,  
         @ o r d e r I D   B I G I N T   =   0  
 A S  
 B E G I N  
 - -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 - -   A u t h o r : 	 	 C r a i g   P a r k s  
 - -   C r e a t e   d a t e :   1 1 / 4 / 2 0 0 8  
 - -   D e s c r i p t i o n : 	 C r e a t e   S a l e s   O r d e r   H i s t o r y   D e t a i l   l i n e s  
 - -   P a r a m e t e r s :     @ u s e r n a m e   =   C a l l i n g   P r o c e s s  
 - -       @ o r d e r I D   r e l e a s e   O r d e r   I D   a n d   H i s t o r y   O r d e r   N u m b e r  
 - -   M o d i f i e d :   1 / 9 / 2 0 0 9   C r a i g   p a r k s   A d d   n e w   D e t a i l   c i l u m n s  
 - -         U s a g e L o c  
 - -   M o d i f i e d :   1 / 1 4 / 2 0 0 9   C S P   A d d   A l t e r n a t e   P r i c e  
 - -   M o d i f i e d   2 / 1 1 / 2 0 0 9   C r a i g   P a r k s   A d d   S u p e r   E q v   a n d   C a r r i e r C d  
 - -   M o d i f i e d   3 / 2 / 2 0 0 9   C r a i g   P a r k s   A d d   c o l u m n   I M L o c N a m e  
 - -   M o d i f i e d :   4 / 2 / 2 0 0 9   C r a i g   P a r k s   A d d   S t k U M  
 - -   M o d i f i e d :   6 / 2 3 / 2 0 0 9   C r a i g   P a r k s   A d d   F r e i g h t C d  
 - -   M o d i f i e d :   8 / 1 3 / 2 0 0 9   C r a i g   P a r k s   M o v e   T r a n s f e r   O r d e r s   t o   T O D e t a i l H i s t  
 - -   M o d i f i e d :   1 1 / 2 / 2 0 0 9   C r a i g   P a r k s   A d d   Q u o t e   R e f e r e n c e   c o l u m n s  
 - - 	 	 ,   R e f e r e n c e N o ,   R e f e r e n c e N o D t  
 - -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 	 - -   S E T   N O C O U N T   O N   a d d e d   t o   p r e v e n t   e x t r a   r e s u l t   s e t s   f r o m  
 	 - -   i n t e r f e r i n g   w i t h   S E L E C T   s t a t e m e n t s .  
 	 S E T   N O C O U N T   O N ;  
  
 I F   ( ( S E L E C T   C A S T ( S u b T y p e   A S   I N T )   F R O M   S O H e a d e r R e l    
 W H E R E   O r d e r N o   =   @ o r d e r I D )   = 5 )   E X E C   [ p S O E C r e a t e T O H i s t O r d D e t a i l ]   @ u s e r n a m e = @ u s e r n a m e ,   @ o r d e r I D = @ o r d e r I D  
 E L S E   B E G I N   - -   C r e a t e   S O D e t a i l H i s t  
 	 I N S E R T   I N T O   d b o . S O D e t a i l H i s t   ( f S O H e a d e r H i s t I D ,   L i n e N u m b e r ,   L i n e S e q ,   L i n e T y p e ,  
 	 L i n e P r i c e I n d ,   L i n e R e a s o n ,   L i n e R e a s o n D s c ,   L i n e E x p d C d ,   L i n e E x p d C d D s c ,   L i n e S t a t u s ,  
 	 P O L i n e ,   T a x S t a t u s ,   I t e m N o ,   I t e m D s c ,   B i n L o c ,   I M L o c ,   D i s c I n d ,   R e l e a s e I n d ,  
 	 C o s t I n d ,   S e r v C h r g I n d ,   X r e f C d ,   O r d e r L v l C d ,   B O L C a t e g o r y C d ,   P r i c e C d ,   D e a l e r C d ,  
 	 L I S C ,   L I S o u r c e ,   R e v L v l ,   Q t y S t a t ,   D e a l e r N o ,   C o m P c t ,   C o m D o l ,   N e t U n i t P r i c e ,  
 	 L i s t U n i t P r i c e ,   D i s c U n i t P r i c e ,   D i s c P c t 1 ,   D i s c P c t 2 ,   D i s c P c t 3 ,   Q t y A v a i l L o c 1 ,  
 	 Q t y A v a i l 1 ,   Q t y A v a i l L o c 2 ,   Q t y A v a i l 2 ,   Q t y A v a i l L o c 3 ,   Q t y A v a i l 3 ,   O r i g O r d e r N o ,  
 	 O r i g O r d e r L i n e N o ,   R q s t d S h i p D t ,   O r i g S h i p D t ,   A c t u a l S h i p D t ,   L i n e S c h D t C h a n g e ,  
 	 S u g g s t d S h i p D t ,   D e l e t e D t ,   Q t y O r d e r e d ,   Q t y S h i p p e d ,   Q t y B O ,   S e l l S t k U M ,   S e l l S t k F a c t o r ,  
 	 U n i t C o s t ,   U n i t C o s t 2 ,   U n i t C o s t 3 ,   R e p C o s t ,   O E C o s t ,   R e b a t e A m t ,   S u g g s t d S h i p F r L o c ,  
 	 S u g g s t d S h i p F r N a m e ,   N o R e s c h d ,   R e m a r k ,   C u s t I t e m N o ,   C u s t I t e m D s c ,   B O M Q t y P e r ,  
 	 B O M Q t y I s s u e d ,   E n t r y D a t e ,   E n t r y I D ,   G r o s s W g h t ,   N e t W g h t ,   E x t e n d e d P r i c e ,  
 	 E x t e n d e d C o s t ,   E x t e n d e d N e t W g h t ,   E x t e n d e d G r o s s W g h t ,   S e l l S t k Q t y ,   A l t e r n a t e U M ,  
 	 A l t e r n a t e U M Q t y ,   S h i p T h r u L o c ,   f S O D e t a i l I D ,   Q t y S t a t u s ,   E x c l u d e d F r o m U s a g e F l a g ,   O r i g i n a l Q t y R e q u e s t e d ,  
 	 U s a g e L o c ,   A l t e r n a t e P r i c e ,   S u p e r E q u i v Q t y ,   S u p e r E q u i v U M ,   C a r r i e r C d ,   I M L o c N a m e ,   S t k U M ,   F r e i g h t C d ,  
 	 C e r t R e q u i r e d I n d ,   R e f e r e n c e N o ,   R e f e r e n c e N o D t )  
 	 - -   G e t   t h e   I D   o f   t h e   H i s t o r y   O r d e r   H e a d e r  
 	 - - T h e   d e t a i l   c o l u m n s   o f   t h e   S O D e t a i l   R e l e a s e  
 	 S E L E C T     S O H H . p S O H e a d e r H i s t I D ,   L i n e N u m b e r ,   L i n e S e q ,   L i n e T y p e ,  
 	 L i n e P r i c e I n d ,   L i n e R e a s o n ,   L i n e R e a s o n D s c ,   L i n e E x p d C d ,   L i n e E x p d C d D s c ,   L i n e S t a t u s ,  
 	 P O L i n e ,   T a x S t a t u s ,   I t e m N o ,   I t e m D s c ,   B i n L o c ,   I M L o c ,   D i s c I n d ,   R e l e a s e I n d ,  
 	 C o s t I n d ,   S e r v C h r g I n d ,   X r e f C d ,   O r d e r L v l C d ,   B O L C a t e g o r y C d ,   S O D R . P r i c e C d ,   D e a l e r C d ,  
 	 L I S C ,   L I S o u r c e ,   R e v L v l ,   Q t y S t a t ,   D e a l e r N o ,   C o m P c t ,   C o m D o l ,   N e t U n i t P r i c e ,  
 	 L i s t U n i t P r i c e ,   D i s c U n i t P r i c e ,   D i s c P c t 1 ,   D i s c P c t 2 ,   D i s c P c t 3 ,   Q t y A v a i l L o c 1 ,  
 	 Q t y A v a i l 1 ,   Q t y A v a i l L o c 2 ,   Q t y A v a i l 2 ,   Q t y A v a i l L o c 3 ,   Q t y A v a i l 3 ,   O r i g O r d e r N o ,  
 	 O r i g O r d e r L i n e N o ,   R q s t d S h i p D t ,   S O D R . O r i g S h i p D t ,   A c t u a l S h i p D t ,   L i n e S c h D t C h a n g e ,  
 	 S u g g s t d S h i p D t ,   S O D R . D e l e t e D t ,   Q t y O r d e r e d ,   Q t y S h i p p e d ,   Q t y B O ,   S e l l S t k U M ,   S e l l S t k F a c t o r ,  
 	 U n i t C o s t ,   U n i t C o s t 2 ,   U n i t C o s t 3 ,   R e p C o s t ,   O E C o s t ,   R e b a t e A m t ,   S u g g s t d S h i p F r L o c ,  
 	 S u g g s t d S h i p F r N a m e ,   N o R e s c h d ,   R e m a r k ,   C u s t I t e m N o ,   C u s t I t e m D s c ,   B O M Q t y P e r ,  
 	 B O M Q t y I s s u e d ,   G e t D a t e ( )   A S   E n t r y D t ,   @ u s e r N a m e ,   G r o s s W g h t ,   N e t W g h t ,   E x t e n d e d P r i c e ,  
 	 E x t e n d e d C o s t ,   E x t e n d e d N e t W g h t ,   E x t e n d e d G r o s s W g h t ,   S e l l S t k Q t y ,   A l t e r n a t e U M ,  
 	 A l t e r n a t e U M Q t y , S O D R . S h i p T h r u L o c , p S O D e t a i l R e l I D , Q t y S t a t u s , E x c l u d e d F r o m U s a g e F l a g ,  
 	 O r i g i n a l Q t y R e q u e s t e d ,   S O D R . U s a g e L o c ,   A l t e r n a t e P r i c e ,   S u p e r E q u i v Q t y ,   S u p e r E q u i v U M ,   C a r r i e r C d ,  
 	 I M L o c N a m e ,   S t k U M ,   F r e i g h t C d ,   S O D R . C e r t R e q u i r e d I n d ,   S O D R . R e f e r e n c e N o ,   S O D R . R e f e r e n c e N o D t  
 	 F R O M   S O H e a d e r H i s t   ( N O L O C K )   S O H H ,  
 	 S O D e t a i l R e l   ( N O L O C K )   S O D R  
 	 W H E R E   S O D R . f S O H e a d e r R e l I D   =   @ o r d e r I D   A N D   S O H H . O r d e r N o   =   @ o r d e r I D  
 	 A N D   S O D R . D e l e t e D t   I S   N U L L  
 E N D   - -   C r e a t e   S O D e t a i l H i s t  
 R E T U R N ( 0 )  
 E N D  
  
  
  
  
  
  
 