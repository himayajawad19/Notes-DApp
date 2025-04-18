// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Notes{
    // Defining Public State Variable. 
    uint public noteCount =0;

    // Defining Skeleton 
     struct Note{
        uint id;
        string title;
        string description;
        // uint timeStamp;
     }
     mapping(uint=>Note)public notes;
     event NoteCreated(uint id, string title, string description );
     event NoteDeleted(uint id);
     event NoteUpdated(uint id, string title, string description);

     function createNote(string memory _title, string memory _description) public {
        notes[noteCount]=Note(noteCount, _title, _description);
        emit NoteCreated(noteCount, _title, _description);
        noteCount++;
     }

     function deleteNote(uint _id)public{
        require(_id < noteCount, "Note does not exist.");
        delete notes[_id];
        emit NoteDeleted(_id);
        noteCount--;
     }

       function updateNote(uint _id,string memory _title, string memory _description) public {
        notes[_id]=Note(_id, _title, _description);
        emit NoteUpdated(_id, _title, _description);
     }

}