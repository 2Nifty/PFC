i f   e x i s t s   ( s e l e c t   *   f r o m   d b o . s y s o b j e c t s   w h e r e   i d   =   o b j e c t _ i d ( N ' [ d b o ] . [ N V $ S a l e s   I n v o i c e   L i n e ] ' )   a n d   O B J E C T P R O P E R T Y ( i d ,   N ' I s U s e r T a b l e ' )   =   1 )  
 d r o p   t a b l e   [ d b o ] . [ N V $ S a l e s   I n v o i c e   L i n e ]  
 G O  
  
 C R E A T E   T A B L E   [ d b o ] . [ N V $ S a l e s   I n v o i c e   L i n e ]   (  
 	 [ t i m e s t a m p ]   [ t i m e s t a m p ]   N O T   N U L L   ,  
 	 [ D o c u m e n t   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ L i n e   N o _ ]   [ i n t ]   N O T   N U L L   ,  
 	 [ S e l l - t o   C u s t o m e r   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ T y p e ]   [ i n t ]   N O T   N U L L   ,  
 	 [ N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ L o c a t i o n   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ P o s t i n g   G r o u p ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ S h i p m e n t   D a t e ]   [ d a t e t i m e ]   N O T   N U L L   ,  
 	 [ D e s c r i p t i o n ]   [ v a r c h a r ]   ( 5 0 )     N O T   N U L L   ,  
 	 [ D e s c r i p t i o n   2 ]   [ v a r c h a r ]   ( 5 0 )     N O T   N U L L   ,  
 	 [ U n i t   o f   M e a s u r e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ Q u a n t i t y ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ U n i t   P r i c e ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ U n i t   C o s t   ( L C Y ) ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ V A T   % ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ L i n e   D i s c o u n t   % ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ L i n e   D i s c o u n t   A m o u n t ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ A m o u n t ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ A m o u n t   I n c l u d i n g   V A T ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ A l l o w   I n v o i c e   D i s c _ ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ G r o s s   W e i g h t ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ N e t   W e i g h t ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ U n i t s   p e r   P a r c e l ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ U n i t   V o l u m e ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ A p p l _ - t o   I t e m   E n t r y ]   [ i n t ]   N O T   N U L L   ,  
 	 [ S h o r t c u t   D i m e n s i o n   1   C o d e ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ S h o r t c u t   D i m e n s i o n   2   C o d e ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ C u s t o m e r   P r i c e   G r o u p ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ J o b   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ A p p l _ - t o   J o b   E n t r y ]   [ i n t ]   N O T   N U L L   ,  
 	 [ P h a s e   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ T a s k   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ S t e p   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ J o b   A p p l i e s - t o   I D ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ A p p l y   a n d   C l o s e   ( J o b ) ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ W o r k   T y p e   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ B i l l - t o   C u s t o m e r   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ I n v _   D i s c o u n t   A m o u n t ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ D r o p   S h i p m e n t ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ G e n _   B u s _   P o s t i n g   G r o u p ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ G e n _   P r o d _   P o s t i n g   G r o u p ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ V A T   C a l c u l a t i o n   T y p e ]   [ i n t ]   N O T   N U L L   ,  
 	 [ T r a n s a c t i o n   T y p e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ T r a n s p o r t   M e t h o d ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ A t t a c h e d   t o   L i n e   N o _ ]   [ i n t ]   N O T   N U L L   ,  
 	 [ E x i t   P o i n t ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ A r e a ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ T r a n s a c t i o n   S p e c i f i c a t i o n ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ T a x   A r e a   C o d e ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ T a x   L i a b l e ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ T a x   G r o u p   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ V A T   B u s _   P o s t i n g   G r o u p ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ V A T   P r o d _   P o s t i n g   G r o u p ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ B l a n k e t   O r d e r   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ B l a n k e t   O r d e r   L i n e   N o _ ]   [ i n t ]   N O T   N U L L   ,  
 	 [ V A T   B a s e   A m o u n t ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ U n i t   C o s t ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ L i n e   A m o u n t ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ V A T   D i f f e r e n c e ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ V A T   I d e n t i f i e r ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ V a r i a n t   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ B i n   C o d e ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ Q t y _   p e r   U n i t   o f   M e a s u r e ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ U n i t   o f   M e a s u r e   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ Q u a n t i t y   ( B a s e ) ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ F A   P o s t i n g   D a t e ]   [ d a t e t i m e ]   N O T   N U L L   ,  
 	 [ D e p r e c i a t i o n   B o o k   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ D e p r _   u n t i l   F A   P o s t i n g   D a t e ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ D u p l i c a t e   i n   D e p r e c i a t i o n   B o o k ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ U s e   D u p l i c a t i o n   L i s t ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ R e s p o n s i b i l i t y   C e n t e r ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ C r o s s - R e f e r e n c e   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ U n i t   o f   M e a s u r e   ( C r o s s   R e f _ ) ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ C r o s s - R e f e r e n c e   T y p e ]   [ i n t ]   N O T   N U L L   ,  
 	 [ C r o s s - R e f e r e n c e   T y p e   N o _ ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ I t e m   C a t e g o r y   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ N o n s t o c k ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ P u r c h a s i n g   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ P r o d u c t   G r o u p   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ A p p l _ - f r o m   I t e m   E n t r y ]   [ i n t ]   N O T   N U L L   ,  
 	 [ S e r v i c e   C o n t r a c t   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ S e r v i c e   O r d e r   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ S e r v i c e   I t e m   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ A p p l _ - t o   S e r v i c e   E n t r y ]   [ i n t ]   N O T   N U L L   ,  
 	 [ S e r v i c e   I t e m   L i n e   N o _ ]   [ i n t ]   N O T   N U L L   ,  
 	 [ S e r v _   P r i c e   A d j m t _   G r _   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ R e t u r n   R e a s o n   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ A l l o w   L i n e   D i s c _ ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ C u s t o m e r   D i s c _   G r o u p ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ P a c k a g e   T r a c k i n g   N o _ ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ U s a g e   L o c a t i o n ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ S a l e s   L o c a t i o n ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ A l t _   Q u a n t i t y ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ A l t _   Q t y _   U O M ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ A l t _   P r i c e ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ A l t _   P r i c e   U O M ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ C e r t   R e q u i r e d ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ C e r t   D e l i v e r y   M e t h o d ]   [ i n t ]   N O T   N U L L   ,  
 	 [ U n i t   P r i c e   O r g i n ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ E D I   I t e m   C r o s s   R e f _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ E D I   U n i t   o f   M e a s u r e ]   [ v a r c h a r ]   ( 2 )     N O T   N U L L   ,  
 	 [ E D I   S e g m e n t   G r o u p ]   [ i n t ]   N O T   N U L L   ,  
 	 [ S h i p p i n g   C h a r g e ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ Q t y _   P a c k e d   ( B a s e ) ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ P a c k ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ R a t e   Q u o t e d ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ S t d _   P a c k a g e   U n i t   o f   M e a s   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ S t d _   P a c k a g e   Q u a n t i t y ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ Q t y _   p e r   S t d _   P a c k a g e ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ S t d _   P a c k a g e   Q t y _   t o   S h i p ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ S t d _   P a c k s   p e r   P a c k a g e ]   [ i n t ]   N O T   N U L L   ,  
 	 [ P a c k a g e   Q u a n t i t y ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ P a c k a g e   Q t y _   t o   S h i p ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ E - S h i p   W h s e _   O u t s t _   Q t y   ( B a s e ) ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ S h i p p i n g   C h a r g e   B O L   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ R e q u i r e d   S h i p p i n g   A g e n t   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ R e q u i r e d   E - S h i p   A g e n t   S e r v i c e ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ A l l o w   O t h e r   S h i p _   A g e n t _ S e r v _ ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ O r d e r   D a t e ]   [ d a t e t i m e ]   N O T   N U L L   ,  
 	 [ M a n u f a c t u r e r   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ T o o l   R e p a i r   T e c h ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ S a l e s p e r s o n   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ I n s i d e   S a l e s p e r s o n   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ P o s t i n g   D a t e ]   [ d a t e t i m e ]   N O T   N U L L   ,  
 	 [ E x t e r n a l   D o c u m e n t   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ L i s t   P r i c e ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ N e t   U n i t   P r i c e ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ S h i p - t o   P O   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ S h i p p i n g   A d v i c e ]   [ i n t ]   N O T   N U L L   ,  
 	 [ R e s o u r c e   G r o u p   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ O r d e r   O u t s t a n d i n g   Q t y _   ( B a s e ) ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ O r d e r   Q u a n t i t y   ( B a s e ) ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ T a g   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ C u s t o m e r   B i n ]   [ v a r c h a r ]   ( 1 2 )     N O T   N U L L   ,  
 	 [ F B   O r d e r   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ F B   L i n e   N o _ ]   [ i n t ]   N O T   N U L L   ,  
 	 [ L i n e   G r o s s   W e i g h t ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ L i n e   N e t   W e i g h t ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ S h i p - t o   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ L i n e   C o s t ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L   ,  
 	 [ I t e m   G r o u p   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ V e n d o r   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ V e n d o r   I t e m   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ P r o d _   O r d e r   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ E x c l _   f r o m   U s a g e ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ E D I   O r i g i n a l   U O M ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ R e s i d e n t i a l   D e l i v e r y ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ F r e e   F r e i g h t ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ C O D   P a y m e n t ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ W o r l d   W i d e   S e r v i c e ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ E - S h i p   A g e n t   C o d e ]   [ v a r c h a r ]   ( 1 0 )     N O T   N U L L   ,  
 	 [ E - S h i p   A g e n t   S e r v i c e ]   [ v a r c h a r ]   ( 3 0 )     N O T   N U L L   ,  
 	 [ S h i p p i n g   P a y m e n t   T y p e ]   [ i n t ]   N O T   N U L L   ,  
 	 [ T h i r d   P a r t y   S h i p _   A c c o u n t   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ S h i p p i n g   I n s u r a n c e ]   [ i n t ]   N O T   N U L L   ,  
 	 [ S h i p m e n t   N o _ ]   [ v a r c h a r ]   ( 2 0 )     N O T   N U L L   ,  
 	 [ S h i p m e n t   L i n e   N o _ ]   [ i n t ]   N O T   N U L L   ,  
 	 [ B a c k   O r d e r ]   [ t i n y i n t ]   N O T   N U L L   ,  
 	 [ B a c k   O r d e r   Q t y ]   [ d e c i m a l ] ( 3 8 ,   2 0 )   N O T   N U L L    
 )  
 G O  
  
 