 
 C R E A T E   P R O C E D U R E   [ d b o ] . [ p S O E C r e a t e H i s t O r d H e a d e r ]    
 	 - -   A d d   t h e   p a r a m e t e r s   f o r   t h e   s t o r e d   p r o c e d u r e   h e r e  
 	 @ u s e r N a m e   V A R C H A R ( 5 0 )   =   0 ,  
         @ o r d e r I D   B I G I N T  
 A S  
 B E G I N  
 - -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 - -   A u t h o r : 	 	 C r a i g   P a r k s  
 - -   C r e a t e   d a t e :   1 2 / 1 / 2 0 0 8  
 - -   D e s c r i p t i o n : 	 C r e a t e   a   H i s t o r y   O r d e r   f r o m   a   R e l e a s e d   o r d e r  
 - -   P a r a m e t e r s :   @ o r d e r I D   =   R e l e a s e   O r d e r   I D   f o r   H i s t o r y   I n v   c r e a t i o n ,  
 - -     @ u s e r N a m e   =   C a l l e r  
 - -   M o d i f i e d :   1 / 9 / 2 0 0 8   C r a i g   P a r k s   A d d e d   n e w   H e a d e r   C o l u m n s    
 - -           D i s c o u n t A m t   t h r o u g h   S h i p C o m p l e t e I n d  
 - -   M o d i f i e d   1 / 2 2 / 2 0 0 9   C r a i g   P a r k s   A d d   R e v i e w I D ,   R e v i e w D T ,   A l l o c R e l D t  
 - -   M o d i f i e d   3 / 3 / 2 0 0 9   C r a i g   P a r k s   A d d   t h e   f o l l o w i n g   c o l u m n s :  
 - -   I n v o i c e S e n d M e t h o d ,   I n v o i c e S e n d D e s t ,   I n v o i c e S e n d D a t e 1 ,   I n v o i c e S e n d D a t e 2 ,  
 - -   I n v o i c e S e n d D a t e 3 ,   I n v o i c e S e n t ,   I n v o i c e F i l e d ,   R e s e n d I n v o i c e ,   R e f i l e I n v o i c e ,  
 - -   D i s c o u n t A m o u n t ,   D i s c o u n t D t ,   A R D u e D t ,   f C u s t o m e r A d d r e s s I D  
 - -   M o d i f i e d :   4 / 1 / 2 0 0 9   C r a i g   P a r k s   S e t   f S O H e a d e r H i s t I D   t o   O r g i n a l   o r d e r I D  
 - -   M o d i f i e d :   4 / 2 / 2 0 0 9   C r a i g   P a r k s   A d d   D e l e t e R e a s o n C d ,   D e l e t e R e a s o n N a m e ,  
 - -   D e l e t e U s e r I D  
 - -   M o d i f i e d :   4 / 1 5 / 2 0 0 9   C r a i g   P a r k s   I n s u r e   R e s e n d I n v o i c e   a n d   I n v o i c e S e n t   a r e   0  
 - -   S e t   E n t r y I D   t o   E n t r y I D   o f   U s e r   w h o   c r e a t e d   O r i g i n a l   O r d e r  
 - -   M o d i f i e d :   5 / 1 / 2 0 0 9   C r a i g   P a r k s   A d d   S h i p p i n g   c o l u m n s  
 - - 	 S h i p T r a c k i n g N o ,   S h i p p i n g C o s t  
 - -   M o d i f i e d :   6 / 2 3 / 2 0 0 9   C r a i g   P a r k s   A d d   D o c u m e n t S o r t I n d  
 - -   M o d i f i e d :   8 / 1 3 / 2 0 0 9   C r a i g   P a r k s   M o v e   T r a n s f e r   O r d e r s   t o   T r a n s f e r   O r d e r   H i s t o r y  
 - -   M o d i f i e d :   8 / 2 0 / 2 0 0 9   C r a i g   P a r k s   M o v e   o r d e r   e x t e n s i o n s   f o r   R e l   t o   H i s t   s e e   T o t a l O r d e r  
 - -   M o d i f i e d :   1 1 / 2 / 2 0 0 9   C r a i g   P a r k s   a d d   R e f e r e n c e N o D t  
 - -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 	 - -   S E T   N O C O U N T   O N   a d d e d   t o   p r e v e n t   e x t r a   r e s u l t   s e t s   f r o m  
 	 - -   i n t e r f e r i n g   w i t h   S E L E C T   s t a t e m e n t s .  
 	 S E T   N O C O U N T   O N ;  
  
         - -   I n s e r t   s t a t e m e n t s   f o r   p r o c e d u r e   h e r e  
 - -   S e e   i f   t h e   H i s t o r y   o r d e r   i s   a   t r a n s f e r  
 I F   ( ( S E L E C T   C A S T ( S u b T y p e   A S   I N T )   F R O M   S O H e a d e r R e l    
 W H E R E   O r d e r N o   =   @ o r d e r I D )   = 5 )   E X E C   [ p S O E C r e a t e T O H i s t O r d H e a d e r ]   @ u s e r n a m e = @ u s e r n a m e ,   @ o r d e r I D = @ o r d e r I D  
 E L S E   B E G I N   - -   I n s e r t   t o   S O H e a d e r H i s t  
 	 I N S E R T   I N T O   d b o . S O H e a d e r H i s t   ( O r d e r N o ,   O r d e r R e l N o ,   O r d e r T y p e ,   O r d e r T y p e D s c ,  
 	 P r i c e C d ,   D i s c o u n t C d ,    
 	 T o t a l O r d e r ,   T o t a l C o s t ,   T o t a l C o s t 2 ,   C o m m D o l ,   C o m m P c t ,   D i s c P c t ,   C o m S p l i t 1 ,   C o m S p l i t 2 , C o m S p l i t 3 , 	  
 	 S l s R e p I d 1 ,   S l s R e p I d 2 ,   S l s R e p I d 3 ,   N e t S a l e s ,   T a x S u m ,   N o n T a x A m t ,   T a x E x p A m t ,   N o n T a x E x p A m t ,  
 	 T a x A m t ,   C r e d i t C d A m t ,   S h i p W g h t ,   B O L W g h t ,   B i l l T o C u s t N o ,    
 	 B i l l T o C u s t N a m e ,   B i l l T o A d d r e s s 1 ,   B i l l T o A d d r e s s 2 ,   B i l l T o A d d r e s s 3 ,  
 	 B i l l T o C i t y ,   B i l l T o S t a t e ,   B i l l T o Z i p ,   B i l l T o P r o v i n c e ,   B i l l T o C o u n t r y ,  
 	 B i l l T o C o n t a c t N a m e ,   B i l l T o C o n t a c t P h o n e N o ,   S e l l T o C u s t N o ,   S e l l T o C u s t N a m e ,  
 	 S e l l T o A d d r e s s 1 ,   S e l l T o A d d r e s s 2 ,   S e l l T o A d d r e s s 3 ,   S e l l T o C i t y ,   S e l l T o S t a t e ,  
 	 S e l l T o Z i p ,   S e l l T o P r o v i n c e ,   S e l l T o C o u n t r y ,   S e l l T o C o n t a c t N a m e ,  
 	 S e l l T o C o n t a c t P h o n e N o ,   D e l e t e D t ,   C o m p l e t e D t ,   V e r i f y D t ,   P r i n t D t ,   I n v o i c e D t ,  
 	 A R P o s t D t ,   S c h S h i p D t ,   C o n f i r m S h i p D t ,   P i c k D t ,   P i c k C o m p D t ,   A l l o c D t ,   H o l d D t ,  
 	 O r d e r D t ,   O r d e r P r o m D t ,   O r d e r L o c ,   O r d e r L o c N a m e ,   S h i p L o c ,   S h i p L o c N a m e ,  
 	 U s a g e L o c ,   U s a g e L o c N a m e ,   O r d e r S t a t u s ,   H o l d R e a s o n ,   H o l d R e a s o n N a m e ,  
 	 P r i c e R v w F l a g ,   R e a s o n C d ,   R e a s o n C d N a m e ,   B O F l a g ,   O r d e r M e t h C d ,   O r d e r M e t h N a m e ,  
 	 O r d e r T e r m s C d ,   O r d e r T e r m s N a m e ,   O r d e r P r i o r i t y C d ,   O r d e r P r i N a m e ,   O r d e r E x p d C d ,  
 	 O r d e r E x p d C d N a m e ,   T a x S t a t ,   C r e d i t S t a t ,   S a l e s R e p N o ,   S a l e s R e p N a m e ,   C u s t S v c R e p N o ,  
 	 C u s t S v c R e p N a m e ,   C o p i e s t o P r i n t ,   O r d e r C a r r i e r ,   O r d e r C a r N a m e ,   C r e d i t A u t h N o ,  
 	 B O L N O ,   N o C a r t o n s ,   S h i p I n s t r C d ,   S h i p I n s t r C d N a m e ,   S a l e s T a x R t ,   P O R e f N o ,   R e s a l e N o ,  
 	 V e r i f y T y p e ,   C o n f i r m D t ,   R l s W h s e D t ,   S t a g e D t ,   S t a g e B i n ,   C o n s o l i d a t e D t ,   C o m I n v P r t D t ,  
 	 S h i p p e d D t ,   C o m m M e d i a ,   S u b T y p e ,   H e a d e r S t a t u s ,   O r i g S h i p D t ,   O r i g S h i p D t 1 ,  
 	 O r i g S h i p D t 2 ,   O r i g S h i p D t 3 ,   O n e T i m e S T N o ,   L i n e s C h a n g e d ,   L i n e I t e m O d o m ,  
 	 N o L a t e r D t ,   C u s t o T y p e ,   c u s t T y p e N a m e ,   S c a n Q t y ,   L i s t C d ,   A c k P r i n t e d D t ,  
 	 C u s t S h i p L o c ,   S h i p T h r u L o c ,   R e o r d e r U s e L o c ,   U s e r 2 ,   U s e r 3 ,   U s e r 4 ,   U s e r 5 ,  
 	 S h i p p i n g M a r k 1 ,   S h i p p i n g M a r k 2 ,   S h i p p i n g M a r k 3 ,   S h i p p i n g M a r k 4 ,   O r d e r R e p r i n t s ,  
 	 D r o p V e n d o r I D ,   D r o p V e n d o r N a m e ,   R e c o m m e n d C a r C d ,   R e c o m m e n d C a r N a m e ,   S u r C h a r g e I n d ,  
 	 S u m m a r y B i l l I n d ,   R e f e r e n c e N o ,   C a s h I t e m O d m ,   C u s t T a x R a t e C d ,   S t a t e T a x C d ,   C o u n t y T a x C d ,  
 	 C i t y T a x C d ,   T a x D i s t r i c t ,   R e m i t C d ,   D i s c N e t 1 P C t ,   D i s c N e t 2 P C t ,   D i s c N e t 3 P C t ,  
 	 A S N F m t ,   J o b N a m e ,   J o b N o ,   J o b L o c a t i o n ,   D e s t i n a t i o n ,   J o b B u i l d i n g ,   A S A P i n d ,  
 	 S h i p T o C d ,   S h i p T o N a m e ,   S h i p T o A d d r e s s 1 ,   S h i p T o A d d r e s s 2 ,   S h i p T o A d d r e s s 3 ,  
 	 C i t y ,   S t a t e ,   Z i p ,   P h o n e N o ,   F a x N o ,   C o n t a c t N a m e ,   C o n t a c t P h o n e N o ,   P r o v i n c e ,  
 	 C o u n t r y ,   C o u n t r y C d ,   E n t r y D t ,   E n t r y I D ,   C u s t P O N o ,   R e f S O N o ,   O r d e r F r e i g h t C d ,  
 	 O r d e r F r e i g h t N a m e ,   P e n d i n g D t ,   S h i p M e t h o d N a m e ,   R e m a r k s ,   T a x R a t e C d ,   C u s t R e q D t ,  
 	 B r a n c h R e q D t ,   O r d e r C o n t a c t N a m e , f S O H e a d e r I D , D i s c o u n t A m t , S h i p T o C o n t a c t I D ,  
 	 S e l l T o C o n t a c t I D , M a k e O r d e r D t , C u s t C a r r i e r A c c t , A l l o w B O I n d , C o n s o l i d a t e O r d e r s I n d ,  
 	 S h i p C o m p l e t e I n d ,   R e v i e w I D ,   R e v i e w D t ,   A l l o c R e l D t ,    
 	 I n v o i c e S e n d M e t h o d ,   I n v o i c e S e n d D e s t ,   I n v o i c e S e n d D a t e 1 ,   I n v o i c e S e n d D a t e 2 ,  
 	 I n v o i c e S e n d D a t e 3 ,   I n v o i c e S e n t ,   I n v o i c e F i l e d ,   R e s e n d I n v o i c e ,   R e f i l e I n v o i c e ,  
 	 D i s c o u n t A m o u n t ,   D i s c o u n t D t ,   A R D u e D t ,   f C u s t o m e r A d d r e s s I D ,   D e l e t e R e a s o n C d ,   D e l e t e R e a s o n N a m e ,  
 	 D e l e t e U s e r I D ,   S h i p T r a c k i n g N o ,   S h i p p i n g C o s t ,   D o c u m e n t S o r t I n d ,   C e r t R e q u i r e d I n d ,   O r d e r S o u r c e ,  
 	 R e f e r e n c e N o D t )  
 	 	 S E L E C T   S R . O r d e r N o ,   S R . O r d e r R e l N o ,   O r d e r T y p e ,   O r d e r T y p e D s c ,  
 	 P r i c e C d ,   D i s c o u n t C d ,  
 	 T o t a l O r d e r ,   T o t a l C o s t ,   T o t a l C o s t 2 ,   C o m m D o l ,   C o m m P c t ,   D i s c P c t ,   C o m S p l i t 1 ,   C o m S p l i t 2 , C o m S p l i t 3 , 	  
 	 S l s R e p I d 1 ,   S l s R e p I d 2 ,   S l s R e p I d 3 ,     N e t S a l e s ,   T a x S u m ,   N o n T a x A m t ,   T a x E x p A m t ,   N o n T a x E x p A m t ,  
 	 T a x A m t ,   C r e d i t C d A m t ,   S h i p W g h t ,   B O L W g h t ,   B i l l T o C u s t N o ,    
 	 B i l l T o C u s t N a m e ,   B i l l T o A d d r e s s 1 ,   B i l l T o A d d r e s s 2 ,   B i l l T o A d d r e s s 3 ,  
 	 B i l l T o C i t y ,   B i l l T o S t a t e ,   B i l l T o Z i p ,   B i l l T o P r o v i n c e ,   B i l l T o C o u n t r y ,  
 	 B i l l T o C o n t a c t N a m e ,   B i l l T o C o n t a c t P h o n e N o ,   S e l l T o C u s t N o ,   S e l l T o C u s t N a m e ,  
 	 S e l l T o A d d r e s s 1 ,   S e l l T o A d d r e s s 2 ,   S e l l T o A d d r e s s 3 ,   S e l l T o C i t y ,   S e l l T o S t a t e ,  
 	 S e l l T o Z i p ,   S e l l T o P r o v i n c e ,   S e l l T o C o u n t r y ,   S e l l T o C o n t a c t N a m e ,  
 	 S e l l T o C o n t a c t P h o n e N o ,   D e l e t e D t ,   C o m p l e t e D t ,   V e r i f y D t ,   P r i n t D t ,   S R . I n v o i c e D t ,  
 	 A R P o s t D t ,   S c h S h i p D t ,   C o n f i r m S h i p D t ,   P i c k D t ,   P i c k C o m p D t ,   A l l o c D t ,   H o l d D t ,  
 	 O r d e r D t ,   O r d e r P r o m D t ,   O r d e r L o c ,   O r d e r L o c N a m e ,   S h i p L O C ,   S h i p L o c N a m e ,  
 	 U s a g e L o c ,   U s a g e L o c N a m e ,   O r d e r S t a t u s ,   H o l d R e a s o n ,   H o l d R e a s o n N a m e ,  
 	 P r i c e R v w F l a g ,   R e a s o n C d ,   R e a s o n C d N a m e ,   B O F l a g ,   O r d e r M e t h C d ,   O r d e r M e t h N a m e ,  
 	 O r d e r T e r m s C d ,   O r d e r T e r m s N a m e ,   O r d e r P r i o r i t y C d ,   O r d e r P r i N a m e ,   O r d e r E x p d C d ,  
 	 O r d e r E x p d C d N a m e ,   T a x S t a t ,   C r e d i t S t a t ,   S a l e s R e p N o ,   S a l e s R e p N a m e ,   C u s t S v c R e p N o ,  
 	 C u s t S v c R e p N a m e ,   C o p i e s t o P r i n t ,   O r d e r C a r r i e r ,   O r d e r C a r N a m e ,   C r e d i t A u t h N o ,  
 	 B O L N O ,   N o C a r t o n s ,   S h i p I n s t r C d ,   S h i p I n s t r C d N a m e ,   S a l e s T a x R t ,   P O R e f N o ,   R e s a l e N o ,  
 	 V e r i f y T y p e ,   C o n f i r m D t ,   R l s W h s e D t ,   S t a g e D t ,   S t a g e B i n ,   C o n s o l i d a t e D t ,   C o m I n v P r t D t ,  
 	 S h i p p e d D t ,   C o m m M e d i a ,   S u b T y p e ,   H e a d e r S t a t u s ,   O r i g S h i p D t ,   O r i g S h i p D t 1 ,  
 	 O r i g S h i p D t 2 ,   O r i g S h i p D t 3 ,   O n e T i m e S T N o ,   L i n e s C h a n g e d ,   0   A S   L i n e O d o m ,  
 	 N o L a t e r D t ,   C u s t o T y p e ,   c u s t T y p e N a m e ,   S c a n Q t y ,   L i s t C d ,   A c k P r i n t e d D t ,  
 	 C u s t S h i p L o c ,   S h i p T h r u L o c ,   R e o r d e r U s e L o c ,   U s e r 2 ,   U s e r 3 ,   U s e r 4 ,   U s e r 5 ,  
 	 S h i p p i n g M a r k 1 ,   S h i p p i n g M a r k 2 ,   S h i p p i n g M a r k 3 ,   S h i p p i n g M a r k 4 ,   O r d e r R e p r i n t s ,  
 	 D r o p V e n d o r I D ,   D r o p V e n d o r N a m e ,   R e c o m m e n d C a r C d ,   R e c o m m e n d C a r N a m e ,   S u r C h a r g e I n d ,  
 	 S u m m a r y B i l l I n d ,   R e f e r e n c e N o ,   C a s h I t e m O d m ,   C u s t T a x R a t e C d ,   S t a t e T a x C d ,   C o u n t y T a x C d ,  
 	 C i t y T a x C d ,   T a x D i s t r i c t ,   R e m i t C d ,   D i s c N e t 1 P C t ,   D i s c N e t 2 P C t ,   D i s c N e t 3 P C t ,  
 	 A S N F m t ,   J o b N a m e ,   J o b N o ,   J o b L o c a t i o n ,   D e s t i n a t i o n ,   J o b B u i l d i n g ,   A S A P i n d ,  
 	 S h i p T o C d ,   S h i p T o N a m e ,   S h i p T o A d d r e s s 1 ,   S h i p T o A d d r e s s 2 ,   S h i p T o A d d r e s s 3 ,  
 	 C i t y ,   S t a t e ,   Z i p ,   P h o n e N o ,   F a x N o ,   C o n t a c t N a m e ,   C o n t a c t P h o n e N o ,   P r o v i n c e ,  
 	 C o u n t r y ,   C o u n t r y C d ,   G e t D a t e ( )   A S   E n t r y D a t e ,     E n t r y I D ,   C u s t P O N o ,   R e f S O N o ,   O r d e r F r e i g h t C d ,  
 	 O r d e r F r e i g h t N a m e ,   P e n d i n g D t ,   S h i p M e t h o d N a m e ,   R e m a r k s ,   T a x R a t e C d ,   C u s t R e q D t ,  
 	 B r a n c h R e q D t ,   O r d e r C o n t a c t N a m e , f S O H e a d e r I D ,   D i s c o u n t A m t , S h i p T o C o n t a c t I D ,  
 	 S e l l T o C o n t a c t I D , M a k e O r d e r D t , C u s t C a r r i e r A c c t , A l l o w B O I n d , C o n s o l i d a t e O r d e r s I n d ,  
 	 S h i p C o m p l e t e I n d ,   R e v i e w I D ,   R e v i e w D t ,   A l l o c R e l D t ,  
 	 I n v o i c e S e n d M e t h o d ,   I n v o i c e S e n d D e s t ,   I n v o i c e S e n d D a t e 1 ,   I n v o i c e S e n d D a t e 2 ,  
 	 I n v o i c e S e n d D a t e 3 ,   0   A S   I n v o i c e S e n t ,   0   A S   I n v o i c e F i l e d ,   0   A S   R e s e n d I n v o i c e ,   0   A S   R e f i l e I n v o i c e ,  
 	 D i s c o u n t A m o u n t ,   D i s c o u n t D t ,   A R D u e D t ,   f C u s t o m e r A d d r e s s I D ,   D e l e t e R e a s o n C d ,   D e l e t e R e a s o n N a m e ,  
 	 D e l e t e U s e r I D ,   S h i p T r a c k i n g N o ,   S h i p p i n g C o s t ,   D o c u m e n t S o r t I n d ,   C e r t R e q u i r e d I n d ,   O r d e r S o u r c e ,  
 	 R e f e r e n c e N o D t  
 	 F R O M   S O H e a d e r R e l   ( N O L O C K )   S R    
 	 W H E R E   p S O H e a d e r R e l I D   =   @ o r d e r I D  
 E N D   - -   C r e a t e   S O H e a d e r H i s t  
 R E T U R N ( 0 )  
 E N D  
  
  
  
  
  
  
  
  
 