C R E A T E   P r o c e d u r e   [ d b o ] . [ p C u s t P r i c e W o r k U n p r o c e s s e d ]  
 	 @ A c t i o n   c h a r ( 1 ) ,  
 	 @ B r a n c h   v a r c h a r ( 1 0 ) ,  
 	 @ C u s t o m e r N o   v a r c h a r ( 1 0 ) ,  
 	 @ C u s t o m e r N a m e   v a r c h a r ( 4 0 ) ,  
 	 @ G r o u p T y p e   c h a r ( 2 ) ,  
 	 @ G r o u p N o   v a r c h a r ( 2 0 ) ,  
 	 @ G r o u p D e s c   v a r c h a r ( 8 0 ) ,  
 	 @ B u y G r o u p N o   n v a r c h a r ( 5 ) ,  
 	 @ B u y G r o u p D e s c   v a r c h a r ( 8 0 ) ,  
 	 @ S a l e s H i s t o r y   d e c i m a l ( 1 8 ,   6 ) ,  
 	 @ G M P c t P r i c e C o s t   d e c i m a l ( 1 8 ,   6 ) ,  
 	 @ G M P c t A v g C o s t   d e c i m a l ( 1 8 ,   6 ) ,  
 	 @ S a l e s H i s t o r y T o t   d e c i m a l ( 1 8 ,   6 ) ,  
 	 @ G M P c t P r i c e C o s t T o t   d e c i m a l ( 1 8 ,   6 ) ,  
 	 @ G M P c t A v g C o s t T o t   d e c i m a l ( 1 8 ,   6 ) ,  
 	 @ S a l e s H i s t o r y E C o m m   d e c i m a l ( 1 8 ,   6 ) ,  
 	 @ G M P c t P r i c e C o s t E C o m m   d e c i m a l ( 1 8 ,   6 ) ,  
 	 @ G M P c t A v g C o s t E C o m m   d e c i m a l ( 1 8 ,   6 ) ,  
 	 @ S a l e s H i s t o r y 1 2 M o   d e c i m a l ( 1 8 ,   6 ) ,  
 	 @ G M P c t P r i c e C o s t 1 2 M o   d e c i m a l ( 1 8 ,   6 ) ,  
 	 @ G M P c t A v g C o s t 1 2 M o   d e c i m a l ( 1 8 ,   6 ) ,  
 	 @ T a r g e t G M P c t   d e c i m a l ( 1 8 ,   6 ) ,  
 	 @ E x i s t i n g C u s t P r i c e P c t   d e c i m a l ( 1 8 ,   6 ) ,  
 	 @ A p p r o v e d   c h a r ( 1 ) ,  
 	 @ E n t r y I D   v a r c h a r ( 5 0 )        
 a s  
 / *  
 	 = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 	 A u t h o r : 	 T o m   S l a t e r  
 	 C r e a t e   d a t e :   3 / 1 5 / 2 0 1 0  
 	 D e s c r i p t i o n :   W o r k   U n p r o c e s s e d C a t e g o r y P r i c e   r e c o r d s   f o r   C a t e g o r y   P r i c e   S c h e d u l e   M a i n t e n a n c e  
 	 A c t i o n :   I   =   I n s e r t ;   U   =   U p d a t e  
  
 	 M o d i f i e d   1 0 / 0 5 / 1 0   ( T M D - W O 2 0 0 2 ) 	 - A d d e d   S a l e s H i s t o r y 1 2 M o   &   G M P c t P r i c e C o s t 1 2 M o  
 	 M o d i f i e d   1 1 / 0 4 / 0 5   ( T M D - W O 2 1 5 2 ) 	 - A d d e d   G M P c t A v g C o s t   &   G M P c t A v g C o s t  
 	 	 	 	 	 - A d d e d   S a l e s H i s t o r y T o t ,   G M P c t P r i c e C o s t T o t   &   G M P c t A v g C o s t T o t  
 	 	 	 	 	 - A d d e d   S a l e s H i s t o r y E C o m m ,   G M P c t P r i c e C o s t E C o m m   &   G M P c t A v g C o s t E C o m m  
 	 = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 * /  
  
 B E G I N  
 	 D E C L A R E   @ E n t r y D a t e   D A T E T I M E  
 	 s e t   @ E n t r y D a t e   =   g e t d a t e ( )  
  
 	 I F   @ A c t i o n   =   ' I '  
 	       B E G I N  
 	 	 I N S E R T   I N T O   U n p r o c e s s e d C a t e g o r y P r i c e  
 	 	 	 	 ( B r a n c h ,  
 	 	 	 	   C u s t o m e r N o ,  
 	 	 	 	   C u s t o m e r N a m e ,  
 	 	 	 	   G r o u p T y p e ,  
 	 	 	 	   G r o u p N o ,  
 	 	 	 	   G r o u p D e s c ,  
 	 	 	 	   B u y G r o u p N o ,  
 	 	 	 	   B u y G r o u p D e s c ,  
 	 	 	 	   S a l e s H i s t o r y ,  
 	 	 	 	   G M P c t P r i c e C o s t ,  
 	 	 	 	   G M P c t A v g C o s t ,  
 	 	 	 	   S a l e s H i s t o r y T o t ,  
 	 	 	 	   G M P c t P r i c e C o s t T o t ,  
 	 	 	 	   G M P c t A v g C o s t T o t ,  
 	 	 	 	   S a l e s H i s t o r y E C o m m ,  
 	 	 	 	   G M P c t P r i c e C o s t E C o m m ,  
 	 	 	 	   G M P c t A v g C o s t E C o m m ,  
 	 	 	 	   S a l e s H i s t o r y 1 2 M o ,  
 	 	 	 	   G M P c t P r i c e C o s t 1 2 M o ,  
 	 	 	 	   G M P c t A v g C o s t 1 2 M o ,  
 	 	 	 	   T a r g e t G M P c t ,  
 	 	 	 	   E x i s t i n g C u s t P r i c e P c t ,  
 	 	 	 	   A p p r o v e d ,  
 	 	 	 	   E n t r y I D ,  
 	 	 	 	   E n t r y D t )  
 	 	 V A L U E S 	 	 ( @ B r a n c h ,  
 	 	 	 	   @ C u s t o m e r N o ,  
 	 	 	 	   @ C u s t o m e r N a m e ,  
 	 	 	 	   @ G r o u p T y p e ,  
 	 	 	 	   @ G r o u p N o ,  
 	 	 	 	   @ G r o u p D e s c ,  
 	 	 	 	   @ B u y G r o u p N o ,  
 	 	 	 	   @ B u y G r o u p D e s c ,  
 	 	 	 	   @ S a l e s H i s t o r y ,  
 	 	 	 	   @ G M P c t P r i c e C o s t ,  
 	 	 	 	   @ G M P c t A v g C o s t ,  
 	 	 	 	   @ S a l e s H i s t o r y T o t ,  
 	 	 	 	   @ G M P c t P r i c e C o s t T o t ,  
 	 	 	 	   @ G M P c t A v g C o s t T o t ,  
 	 	 	 	   @ S a l e s H i s t o r y E C o m m ,  
 	 	 	 	   @ G M P c t P r i c e C o s t E C o m m ,  
 	 	 	 	   @ G M P c t A v g C o s t E C o m m ,  
 	 	 	 	   @ S a l e s H i s t o r y 1 2 M o ,  
 	 	 	 	   @ G M P c t P r i c e C o s t 1 2 M o ,  
 	 	 	 	   @ G M P c t A v g C o s t 1 2 M o ,  
 	 	 	 	   @ T a r g e t G M P c t ,  
 	 	 	 	   @ E x i s t i n g C u s t P r i c e P c t ,  
 	 	 	 	   @ A p p r o v e d ,  
 	 	 	 	   @ E n t r y I D ,  
 	 	 	 	   @ E n t r y D a t e )  
 	       E N D  
 	        
 	 I F   @ A c t i o n   =   ' U '  
 	       B E G I N  
 	 	 U P D A T E 	 U n p r o c e s s e d C a t e g o r y P r i c e  
 	 	 S E T 	 A p p r o v e d   =   @ A p p r o v e d ,  
 	 	 	 T a r g e t G M P c t   =   @ T a r g e t G M P c t ,  
 	 	 	 E x i s t i n g C u s t P r i c e P c t   =   @ E x i s t i n g C u s t P r i c e P c t ,  
 	 	 	 C h a n g e I D   =   @ E n t r y I D ,  
 	 	 	 C h a n g e D t   =   @ E n t r y D a t e  
 	 	 W H E R E 	 C u s t o m e r N o   =   @ C u s t o m e r N o   A N D   G r o u p N o   =   @ G r o u p N o  
 	       E N D  
 E N D  
  
  
 