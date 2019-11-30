Class {
	#name : #GrdSample,
	#superclass : #Object,
	#category : #Guirlande
}

{ #category : #expressions }
GrdSample >> addition [
" - / \ * ~ < > = @ % | & ? , "
	^2+2
]

{ #category : #expressions }
GrdSample >> and [
" - / \ * ~ < > = @ % | & ? , "
	2&2
]

{ #category : #blocks }
GrdSample >> block2 [
	[ :a :b |  a = 2 + b]
]

{ #category : #blocks }
GrdSample >> blok2Value [
	
	[ :a |  a + 2] value: 3
]

{ #category : #blocks }
GrdSample >> blokAssignment [
	|a |
	a := [2]
	
]

{ #category : #blocks }
GrdSample >> blokMoreValues [
	
	[ :a : b |  a + b] value: 3 value: 4
]

{ #category : #expressions }
GrdSample >> combination [
" - / \ * ~ < > = @ % | & ? , "
	2+1*8
]

{ #category : #expressions }
GrdSample >> concatenationString [
" - / \ * ~ < > = @ % | & ? , "
	'Hi','hi'
]

{ #category : #expressions }
GrdSample >> exampleNew [
	'http://www.pharo.org' asUrl retrieveContents.
	('2014-07-01' asDate - '2013/2/1' asDate) days.
	42 factorial decimalDigitLength.
	(ZnServer startDefaultOn: 8080) 
  	onRequestRespond: [ :request | 
   ZnResponse ok: (ZnEntity with: DateAndTime now printString) ].
	$/ join: ($- split: '1969-07-20') reverse.
	(FileLocator workingDirectory filesMatching: '*.jpg') do: [ :each |
  	(each withExtension: 'png') writeStreamDo: [ :out |
    each readStreamDo: [ :in |
      (PNGReadWriter on: out) nextPutImage: 
        (JPEGReadWriter on: in) nextImage ] ] ].
	(Integer primesUpTo: 64) sum.
	DateAndTime fromUnixTime:
  	((ByteArray readHexFrom: 'CAFEBABE4422334400FF') 
      copyFrom: 5 to: 8) asInteger.
	
	
]

{ #category : #blocks }
GrdSample >> justBlokIf [

		#(1 2 3) do: [ :each | true ifTrue:[each]]
		

]

{ #category : #selectors }
GrdSample >> justIfFalse [
	false ifFalse:[0]
	
]

{ #category : #selectors }
GrdSample >> justIfTrue [
	true ifTrue:[1]
	
]

{ #category : #blocks }
GrdSample >> justIfTrueBlok [
	true ifTrue:[
		#(1 2 3) do: [ :each | each ]
		]
	
]

{ #category : #blocks }
GrdSample >> justIfTrueBlokIf [
	true ifTrue:[
		#(1 2 3) do: [ :each | true ifTrue:[each]]
		]

]

{ #category : #blocks }
GrdSample >> justIfTrueFalseBlokIf [
	true 
		ifTrue:[#(1 2 3) 
			do: [ :each | true ifTrue:[each] ifFalse:[23]]]
	

]

{ #category : #selectors }
GrdSample >> loopDo [
	#( 15 19 10) do: [ :i |  i ]
]

{ #category : #selectors }
GrdSample >> loopDo: aCollection [
	aCollection do: [ :i |  i ]
]

{ #category : #selectors }
GrdSample >> loopExample [
	 #(1 2 3 4) from: 1 to: 4 do: [ :i |  i ]
]

{ #category : #expressions }
GrdSample >> multiplication [
" - / \ * ~ < > = @ % | & ? , "
	2*2
]

{ #category : #accessing }
GrdSample >> onlyArray [
	#(1 2 3)
	
]

{ #category : #accessing }
GrdSample >> onlyAssignment [
	|a|
	a := 2.
	
]

{ #category : #accessing }
GrdSample >> onlyCascadeStatement [
|a|
		
a := 3
a abs; gcd: 7

	
]

{ #category : #accessing }
GrdSample >> onlyConstant [
	23
	
]

{ #category : #accessing }
GrdSample >> onlyMethod [

	| aNumber anotherNumber |  

	aNumber := 3. 
	anotherNumber  := 7. 
	aNumber gcd: anotherNumber
	
]

{ #category : #accessing }
GrdSample >> onlyReturn [

	^ 42
]

{ #category : #accessing }
GrdSample >> onlyReturnMessageResult [

	^ 42 abs 
]

{ #category : #accessing }
GrdSample >> onlyStatement [
 2*3
	
]

{ #category : #selectors }
GrdSample >> pureReturnIfFalseIfTrue [

	^ true
			ifFalse: [ 11 ]
			ifTrue: [ 22 ]
	
]

{ #category : #selectors }
GrdSample >> pureReturnIfTrueIfFalse [

	^ true
			ifTrue: [ 33 ]
			ifFalse: [ 42 ]
	
]

{ #category : #selectors }
GrdSample >> pureReturnOneBranch [
	^ true
		ifTrue: [ 33 ]
	
]

{ #category : #expressions }
GrdSample >> subtraction [
" - / \ * ~ < > = @ % | & ? , "
	2-2
]

{ #category : #accessing }
GrdSample >> today:today tommorow: tommorow [
^ today + tommorow

]
