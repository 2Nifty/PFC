i f   e x i s t s   ( s e l e c t   *   f r o m   d b o . s y s o b j e c t s   w h e r e   i d   =   o b j e c t _ i d ( N ' [ d b o ] . [ N V $ S a l e s   I n v o i c e   H e a d e r ] ' )   a n d   O B J E C T P R O P E R T Y ( i d ,   N ' I s U s e r T a b l e ' )   =   1 )  
 d r o p   t a b l e   [ d b o ] . [ N V $ S a l e s   I n v o i c e   H e a d e r ]  
 G O  
  
 C R E A T E   T A B L E   [ d b o ] . [ N V $ S a l e s   I n v o i c e   H e a d e r ]   (  
 	 [ t i m e s t a m p ]   [ t i m e s t a m p ]   N O T   N U L L   ,  
 	 [ N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ S e l l - t o   C u s t o m e r   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ B i l l - t o   C u s t o m e r   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ B i l l - t o   N a m e ]   [ v a r c h a r ]   ( 5 0 )     N O T   N U L L   ,  
 	 [ B i l l - t o   N a m e   2 ]   [ v a r c h a r ]   ( 5 0 )     N O T   N U L L   ,  
 	 [ B i l l - t o   A d d r e s s ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ B i l l - t o   A d d r e s s   2 ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ B i l l - t o   C i t y ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ B i l l - t o   C o n t a c t ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ Y o u r   R e f e r e n c e ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ S h i p - t o   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ S h i p - t o   N a m e ]   [ v a r c h a r ]   ( 5 0 )     N O T   N U L L   ,  
 	 [ S h i p - t o   N a m e   2 ]   [ v a r c h a r ]   ( 5 0 )     N O T   N U L L   ,  
 	 [ S h i p - t o   A d d r e s s ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ S h i p - t o   A d d r e s s   2 ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ S h i p - t o   C i t y ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ S h i p - t o   C o n t a c t ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ O r d e r   D a t e ]   [ d a t e t i m e ]   N O T   N U L L   ,  
 	 [ P o s t i n g   D a t e ]   [ d a t e t i m e ]   N O T   N U L L   ,  
 	 [ S h i p m e n t   D a t e ]   [ d a t e t i m e ]   N O T   N U L L   ,  
 	 [ P o s t i n g   D e s c r i p t i o n ]   [ v a r c h a r ]   ( 5 0 )     N O T   N U L L   ,  
 	 [ P a y m e n t   T e r m s   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ D u e   D a t e ]   [ d a t e t i m e ]   N O T   N U L L   ,  
 	 [ P a y m e n t   D i s c o u n t   % ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ P m t _   D i s c o u n t   D a t e ]   [ d a t e t i m e ]   N O T   N U L L   ,  
 	 [ S h i p m e n t   M e t h o d   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ L o c a t i o n   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ S h o r t c u t   D i m e n s i o n   1   C o d e ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ S h o r t c u t   D i m e n s i o n   2   C o d e ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ C u s t o m e r   P o s t i n g   G r o u p ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ C u r r e n c y   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ C u r r e n c y   F a c t o r ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ C u s t o m e r   P r i c e   G r o u p ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ P r i c e s   I n c l u d i n g   V A T ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ I n v o i c e   D i s c _   C o d e ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ C u s t o m e r   D i s c _   G r o u p ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ L a n g u a g e   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ S a l e s p e r s o n   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ O r d e r   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ N o _   P r i n t e d ]   [ i n t ]   N O T   N U L L   ,  
 	 [ O n   H o l d ]   [ v a r c h a r ]   ( 3 )     N O T   N U L L   ,  
 	 [ A p p l i e s - t o   D o c _   T y p e ]   [ i n t ]   N O T   N U L L   ,  
 	 [ A p p l i e s - t o   D o c _   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ B a l _   A c c o u n t   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ J o b   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ V A T   R e g i s t r a t i o n   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ R e a s o n   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ G e n _   B u s _   P o s t i n g   G r o u p ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ E U   3 - P a r t y   T r a d e ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ T r a n s a c t i o n   T y p e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ T r a n s p o r t   M e t h o d ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ V A T   C o u n t r y   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ S e l l - t o   C u s t o m e r   N a m e ]   [ v a r c h a r ]   ( 5 0 )     N O T   N U L L   ,  
 	 [ S e l l - t o   C u s t o m e r   N a m e   2 ]   [ v a r c h a r ]   ( 5 0 )     N O T   N U L L   ,  
 	 [ S e l l - t o   A d d r e s s ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ S e l l - t o   A d d r e s s   2 ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ S e l l - t o   C i t y ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ S e l l - t o   C o n t a c t ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ B i l l - t o   P o s t   C o d e ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ B i l l - t o   C o u n t y ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ B i l l - t o   C o u n t r y   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ S e l l - t o   P o s t   C o d e ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ S e l l - t o   C o u n t y ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ S e l l - t o   C o u n t r y   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ S h i p - t o   P o s t   C o d e ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ S h i p - t o   C o u n t y ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ S h i p - t o   C o u n t r y   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ B a l _   A c c o u n t   T y p e ]   [ i n t ]   N O T   N U L L   ,  
 	 [ E x i t   P o i n t ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ C o r r e c t i o n ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ D o c u m e n t   D a t e ]   [ d a t e t i m e ]   N O T   N U L L   ,  
 	 [ E x t e r n a l   D o c u m e n t   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ A r e a ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ T r a n s a c t i o n   S p e c i f i c a t i o n ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ P a y m e n t   M e t h o d   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ S h i p p i n g   A g e n t   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ P a c k a g e   T r a c k i n g   N o _ ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ P r e - A s s i g n e d   N o _   S e r i e s ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ N o _   S e r i e s ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ O r d e r   N o _   S e r i e s ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ P r e - A s s i g n e d   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ U s e r   I D ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ S o u r c e   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ T a x   A r e a   C o d e ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ T a x   L i a b l e ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ V A T   B u s _   P o s t i n g   G r o u p ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ V A T   B a s e   D i s c o u n t   % ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ C a m p a i g n   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ S e l l - t o   C o n t a c t   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ B i l l - t o   C o n t a c t   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ R e s p o n s i b i l i t y   C e n t e r ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ S e r v i c e   M g t _   D o c u m e n t ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ A l l o w   L i n e   D i s c _ ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ S h i p - t o   U P S   Z o n e ]   [ v a r c h a r ]   ( 2 )     N O T   N U L L   ,  
 	 [ T a x   E x e m p t i o n   N o _ ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ U s a g e   L o c a t i o n ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ S a l e s   L o c a t i o n ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ O r d e r   T y p e ]   [ i n t ]   N O T   N U L L   ,  
 	 [ U n i t   P r i c e   O r g i n ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ E D I   O r d e r ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ E D I   I n t e r n a l   D o c _   N o _ ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ E D I   I n v o i c e   G e n e r a t e d ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ E D I   I n v _   G e n _   D a t e ]   [ d a t e t i m e ]   N O T   N U L L   ,  
 	 [ E D I   A c k _   G e n e r a t e d ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ E D I   A c k _   G e n _   D a t e ]   [ d a t e t i m e ]   N O T   N U L L   ,  
 	 [ E D I   W H S E   S h p _   G e n ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ E D I   W H S E   S h p _   G e n   D a t e ]   [ d a t e t i m e ]   N O T   N U L L   ,  
 	 [ E D I   T r a d e   P a r t n e r ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ E D I   S e l l - t o   C o d e ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ E D I   S h i p - t o   C o d e ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ E D I   S h i p - f o r   C o d e ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ E - S h i p   A g e n t   S e r v i c e ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ R e s i d e n t i a l   D e l i v e r y ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ F r e e   F r e i g h t ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ C O D   P a y m e n t ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ W o r l d   W i d e   S e r v i c e ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ B l i n d   S h i p m e n t ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ D o u b l e   B l i n d   S h i p m e n t ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ D o u b l e   B l i n d   S h i p - f r o m   C u s t   N o ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ N o   F r e e   F r e i g h t   L i n e s   o n   O r d e r ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ S h i p p i n g   P a y m e n t   T y p e ]   [ i n t ]   N O T   N U L L   ,  
 	 [ T h i r d   P a r t y   S h i p _   A c c o u n t   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ S h i p p i n g   I n s u r a n c e ]   [ i n t ]   N O T   N U L L   ,  
 	 [ S h i p - f o r   C o d e ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ E x t e r n a l   S e l l - t o   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ E x t e r n a l   S h i p - t o   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ E x t e r n a l   S h i p - f o r   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ I n v o i c e   f o r   B i l l   o f   L a d i n g   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ E - M a i l   C o n f i r m a t i o n   H a n d l e d ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ E - M a i l   I n v o i c e   N o t i c e   H a n d l e d ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ E n t e r e d   U s e r   I D ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ E n t e r e d   D a t e ]   [ d a t e t i m e ]   N O T   N U L L   ,  
 	 [ E n t e r e d   T i m e ]   [ d a t e t i m e ]   N O T   N U L L   ,  
 	 [ T o o l   R e p a i r   T e c h ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ I n s i d e   S a l e s p e r s o n   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ P h o n e   N o _ ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ F a x   N o _ ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ E - M a i l ]   [ v a r c h a r ]   ( 8 0 )     N O T   N U L L   ,  
 	 [ S h i p - t o   P O   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ B r o k e r _ A g e n t   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ F B   O r d e r   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ T o o l   R e p a i r   P r i o r i t y ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ M a n u f a c t u r e r   C o d e ]   [ v a r c h a r ]   ( 5 )     N O T   N U L L   ,  
 	 [ S e r i a l   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ T o o l   M o d e l   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ T o o l   I t e m   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ T o o l   D e s c r i p t i o n ]   [ v a r c h a r ]   ( 5 0 )     N O T   N U L L   ,  
 	 [ T o o l   R e p a i r   T i c k e t ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ T o o l   R e p a i r   P a r t s   W a r r a n t y ]   [ v a r c h a r ]   ( 3 2 )     N O T   N U L L   ,  
 	 [ T o o l   R e p a i r   L a b o r   W a r r a n t y ]   [ v a r c h a r ]   ( 3 2 )     N O T   N U L L   ,  
 	 [ D a t e   S e n t ]   [ d a t e t i m e ]   N O T   N U L L   ,  
 	 [ T i m e   S e n t ]   [ d a t e t i m e ]   N O T   N U L L   ,  
 	 [ B i z T a l k   S a l e s   I n v o i c e ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ C u s t o m e r   O r d e r   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ B i z T a l k   D o c u m e n t   S e n t ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ E x c l _   f r o m   U s a g e ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ e C o n n e c t   R e f _   N o _ ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ T o t a l   F r e i g h t ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ T o t a l   T a x ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ e C o n n e c t   O r d e r ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ e C o n n e c t   O r d e r   S t a t u s ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ C r e d i t   C a r d   I D ]   [ v a r c h a r ]   ( 5 0 )     N O T   N U L L   ,  
 	 [ C r e d i t   C a r d   N o ]   [ v a r c h a r ]   ( 2 5 0 )     N O T   N U L L   ,  
 	 [ C r e d i t   C a r d   M o n t h ]   [ i n t ]   N O T   N U L L   ,  
 	 [ C r e d i t   C a r d   Y e a r ]   [ i n t ]   N O T   N U L L   ,  
 	 [ C r e d i t   C a r d   N a m e ]   [ v a r c h a r ]   ( 5 0 )     N O T   N U L L   ,  
 	 [ G e t   S h i p m e n t   U s e d ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ I n v o i c e   D e t a i l   S o r t ]   [ i n t ]   N O T   N U L L   ,  
 	 [ C o n t r a c t N o ]   [ v a r c h a r ]   ( 2 5 )      
 )  
 G O  
  
 