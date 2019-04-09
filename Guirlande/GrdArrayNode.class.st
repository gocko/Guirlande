Class {
	#name : #GrdArrayNode,
	#superclass : #GrdNode,
	#instVars : [
		'value'
	],
	#category : #Guirlande
}

{ #category : #'as yet unclassified' }
GrdArrayNode >> printOn: aStream [

	super printOn: aStream.
	aStream nextPutAll: ' ' , value printString 
]

{ #category : #'as yet unclassified' }
GrdArrayNode >> value [
	^ value
]

{ #category : #'as yet unclassified' }
GrdArrayNode >> value: anObject [
	value := anObject
]
