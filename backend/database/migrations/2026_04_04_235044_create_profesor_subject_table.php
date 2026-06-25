<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    
    public function up()
    {
        Schema::create('profesor_subject', function (Blueprint $table) {
            $table->id();
            $table->foreignId('profesor_id')->constrained('profesores')->onDelete('cascade');
            $table->foreignId('subject_id')->constrained()->onDelete('cascade');

            $table->foreignId('tenant_id')->constrained()->onDelete('cascade');

            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('profesor_subject');
    }
};
